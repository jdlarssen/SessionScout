"""Render the actual UI.lua layout with fictional data, without starting WoW.

This is a layout aid, not a client screenshot or runtime compatibility test.
Uses the read-only integration-test lifecycle mock and adds geometry recording.
WoW fonts, native button textures, wrapping, and focus remain approximations.
Run with bundled Python and .tools/python/lupa available from the repo root.
"""
from __future__ import annotations

import hashlib
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".tools" / "python"))
from lupa.lua51 import LuaRuntime

OUT = ROOT / ".tools" / "previews"

INSTRUMENT = r'''
function instrument(ns, env, state)
    local methods = getmetatable(ns.events).__index
    local oldFontString = methods.CreateFontString
    function methods:CreateFontString(name, layer, font)
        local f = oldFontString(self, name)
        f.layer, f.font = layer, font
        return f
    end
    function methods:SetPoint(...) self.point = {...} end
    function methods:ClearAllPoints() self.point = nil end
    function methods:SetAllPoints(relative) self.allPoints = relative or self.parent end
    function methods:SetJustifyH(value) self.justifyH = value end
    function methods:SetJustifyV(value) self.justifyV = value end
    function methods:SetTextColor(...) self.textColor = {...} end
    function methods:SetBackdrop(value) self.backdrop = value end
    function methods:SetBackdropColor(...) self.backdropColor = {...} end
    function methods:SetBackdropBorderColor(...) self.borderColor = {...} end
    function methods:SetAlpha(value) self.alpha = value end
    function methods:SetFontObject(value) self.font = value end
    function methods:SetFont(path, size) self.fontSize = size end
    function methods:SetEnabled(value) self.enabled = value end
    function methods:Enable() self.enabled = true end
    function methods:Disable() self.enabled = false end
    function methods:SetTextInsets(...) self.insets = {...} end
    function methods:SetFrameLevel(value) self.frameLevel = value end
    function methods:GetFrameLevel() return self.frameLevel or 0 end
    function methods:SetNormalFontObject(value) self.font = value end
    function methods:SetHighlightFontObject(value) self.highlightFont = value end
    function methods:SetDisabledFontObject(value) self.disabledFont = value end
    function methods:SetColorTexture(...) self.textureColor = {...} end
    function methods:SetTexture(value) self.texture = value end
    function methods:SetVertexColor(...) self.textureColor = {...} end
    function methods:SetNormalTexture(value) self.normalTexture = value end
    function methods:SetHighlightTexture(value) self.highlightTexture = value end
    function methods:SetPushedTexture(value) self.pushedTexture = value end
    function methods:SetChecked(value) self.checked = value end
    function methods:GetChecked() return self.checked end
    local oldCreate = env.CreateFrame
    env.CreateFrame = function(kind, name, parent, template)
        local f = oldCreate(kind, name, parent)
        f.template = template
        return f
    end
    function methods:CreateTexture(name, layer)
        local f = env.CreateFrame("Texture", name, self)
        f.layer = layer
        return f
    end
    env.UIParent.width, env.UIParent.height = 1920, 1080
end
'''


def table_values(value):
    return [value[i] for i in range(1, len(value) + 1)] if value is not None else None


def make_world(budget):
    lua = LuaRuntime(unpack_returned_tuples=True)
    # Do not execute the tests; reuse only their mocked lifecycle loader.
    harness = (ROOT / "tests" / "integration_spec.lua").read_text(encoding="utf-8")
    marker = '\ntest("'
    if marker not in harness:
        raise RuntimeError("Cannot locate the integration harness boundary")
    world = lua.execute(harness.split(marker, 1)[0] + "\nreturn world")
    ns, env, state = world(None, lua.table_from({"budget": budget, "note": "Meet the group in Orgrimmar."}))
    lua.execute(INSTRUMENT)
    lua.globals().instrument(ns, env, state)
    state.login(state)
    fictional = [
        ("Mahrez Cowl", 30, True),
        ("RFK - look for an amulet upgrade", 120, False),
        ("SM Graveyard - look for a shoulder upgrade", 120, False),
        ("Strahnbrad Mystery", 30, True),
        ("Gnomeregan - look for a tankard", 120, False),
    ]
    for label, minutes, completed in fictional:
        result = ns.Model.AddTask(ns.db, lua.table_from({"label": label, "minutes": minutes, "priority": 2}))
        task = result[0] if isinstance(result, tuple) else result
        if completed:
            ns.Model.CompleteTask(ns.db, task.id, ns.character, ns.Now(), ns.ResetTimes())
    state.open(state)
    return lua, ns, env, state


def snapshot(ns, state):
    frames = list(state.frames.values())
    for i, frame in enumerate(frames):
        frame.previewID = i
    result = []
    for frame in frames:
        point = []
        for value in table_values(frame.point) or []:
            point.append({"frame": value.previewID} if hasattr(value, "previewID") else value)
        fields = {key: frame[key] for key in [
            "kind", "name", "text", "font", "fontSize", "width", "height", "shown", "scale",
            "justifyH", "justifyV", "wordWrap", "maxLines", "template", "alpha", "enabled", "frameLevel",
        ]}
        fields.update({
            "id": frame.previewID,
            "parent": frame.parent.previewID if frame.parent is not None else None,
            "point": point,
            "allPoints": frame.allPoints.previewID if frame.allPoints is not None else None,
            "color": table_values(frame.textColor),
            "fill": table_values(frame.backdropColor),
            "border": table_values(frame.borderColor),
            "textureColor": table_values(frame.textureColor),
        })
        result.append(fields)
    return result, ns.window.previewID


def rgba(values, default):
    if not values:
        return default
    rgb = [round(float(v) * 255) for v in values[:3]]
    return f"rgba({rgb[0]},{rgb[1]},{rgb[2]},{values[3] if len(values) > 3 else 1})"


def rich_text(text):
    # Escape ordinary characters; interpret only WoW's explicit color escapes.
    parts, opened = [], False
    for token in re.split(r"(\|c[0-9a-fA-F]{8}|\|r)", str(text or "")):
        if re.fullmatch(r"\|c[0-9a-fA-F]{8}", token):
            if opened:
                parts.append("</span>")
            parts.append(f'<span style="color:#{token[-6:]}">')
            opened = True
        elif token == "|r":
            if opened:
                parts.append("</span>")
                opened = False
        else:
            parts.append(html.escape(token).replace("\n", "<br/>"))
    if opened:
        parts.append("</span>")
    return "".join(parts)


ANCHORS = {
    "TOPLEFT": (0, 0), "TOP": (.5, 0), "TOPRIGHT": (1, 0),
    "LEFT": (0, .5), "CENTER": (.5, .5), "RIGHT": (1, .5),
    "BOTTOMLEFT": (0, 1), "BOTTOM": (.5, 1), "BOTTOMRIGHT": (1, 1),
}


def render(frames, root_id, name, title, digest):
    by_id = {f["id"]: f for f in frames}
    root = by_id[root_id]
    box_cache = {}

    def font_size(f):
        name = str(f["font"] or "GameFontNormal")
        return f["fontSize"] or (17 if "Large" in name else 11 if "Small" in name else 13)

    def box(i):
        if i in box_cache:
            return box_cache[i]
        f = by_id[i]
        if i == root_id:
            bounds = (24, 120, f["width"], f["height"])
        elif f["allPoints"] is not None:
            bounds = box(f["allPoints"])
        else:
            w = f["width"] or max(1, len(re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", f["text"] or "")) * font_size(f) * .59)
            h = f["height"] or font_size(f) * 1.35
            p = f["point"]
            anchor, relative, rel_anchor, dx, dy = "TOPLEFT", f["parent"], "TOPLEFT", 0, 0
            if p:
                anchor = p[0]
                rel_anchor = anchor
                if len(p) == 3 and isinstance(p[1], (int, float)):
                    dx, dy = p[1:]
                elif len(p) >= 4 and isinstance(p[1], dict):
                    relative = p[1]["frame"]
                    if isinstance(p[2], str):
                        rel_anchor = p[2]
                        dx, dy = p[3:5] if len(p) >= 5 else (0, 0)
                    else:
                        dx, dy = p[2:4]
            px, py, pw, ph = box(relative) if relative is not None else (0, 0, 1920, 1080)
            ax, ay = ANCHORS[anchor]
            rx, ry = ANCHORS[rel_anchor]
            bounds = (px + pw * rx + dx - w * ax, py + ph * ry - dy - h * ay, w, h)
        box_cache[i] = bounds
        return bounds

    def visible(f):
        if not f["shown"]:
            return False
        if f["id"] == root_id:
            return True
        return f["parent"] is not None and visible(by_id[f["parent"]])

    width = int(root["width"] + 48)
    height = int(root["height"] + 165)
    elements = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#20282d"/>',
        '<text x="24" y="26" font-family="Arial,sans-serif" font-size="16" fill="#ffffff">SOURCE-DERIVED LAYOUT PREVIEW — NOT A WOW SCREENSHOT</text>',
        f'<text x="24" y="49" font-family="Arial,sans-serif" font-size="13" fill="#cdd7dd">{html.escape(title)}</text>',
        '<text x="24" y="69" font-family="Arial,sans-serif" font-size="11" fill="#a7b6bf">Fictional tasks. Actual UI.lua geometry and visibility; approximate fonts, wrapping and button textures.</text>',
        f'<text x="24" y="89" font-family="Arial,sans-serif" font-size="11" fill="#a7b6bf">UI.lua SHA256: {digest[:20]}… · No client input, runtime or compatibility validation.</text>',
    ]
    visible_frames = []
    for f in frames:
        if not visible(f):
            continue
        x, y, w, h = box(f["id"])
        visible_frames.append({**f, "bounds": [x, y, w, h]})
        kind = f["kind"]
        if f["fill"] or f["textureColor"] or kind in ("Button", "EditBox", "CheckButton"):
            fill = rgba(f["fill"] or f["textureColor"], "#47100e" if kind == "Button" else "#0b1318")
            border = rgba(f["border"], "#927a4d" if kind == "Button" else "#75664c")
            elements.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{2 if kind in ("Button", "EditBox") else 0}" fill="{fill}" stroke="{border}"/>')
        if not f["text"]:
            continue
        color = rgba(f["color"], "#819097" if "Disable" in str(f["font"]) else "#e5e9e9" if "Highlight" in str(f["font"]) or kind == "EditBox" else "#ffd100")
        align = str(f["justifyH"] or ("CENTER" if kind == "Button" else "LEFT")).lower()
        wrap = "normal" if f["wordWrap"] else "nowrap"
        center = "display:flex;align-items:center;" if kind in ("Button", "EditBox") else ""
        justify = "justify-content:center;" if align == "center" and kind == "Button" else ""
        pad = "padding-left:5px;" if kind == "EditBox" else ""
        elements.append(f'<foreignObject x="{x}" y="{y}" width="{w}" height="{h}"><div xmlns="http://www.w3.org/1999/xhtml" style="width:100%;height:100%;box-sizing:border-box;overflow:hidden;font-family:Arial,sans-serif;font-size:{font_size(f)}px;line-height:1.22;color:{color};text-align:{align};white-space:{wrap};{center}{justify}{pad}"><span>{rich_text(f["text"])}</span></div></foreignObject>')
    elements.append('</svg>')
    svg = "\n".join(elements)
    (OUT / f"{name}.svg").write_text(svg, encoding="utf-8")
    (OUT / f"{name}.html").write_text('<!doctype html><html lang="en"><meta charset="utf-8"><title>SessionScout layout preview</title><body style="margin:0;background:#20282d">' + svg + '</body></html>', encoding="utf-8")
    (OUT / f"{name}.json").write_text(json.dumps({"label": "source-derived layout preview; not client validation", "source_sha256": digest, "frames": visible_frames}, indent=2), encoding="utf-8")
    return OUT / f"{name}.html"


def main():
    import os
    os.chdir(ROOT)
    OUT.mkdir(parents=True, exist_ok=True)
    digest = hashlib.sha256((ROOT / "SessionScout" / "UI.lua").read_bytes()).hexdigest()
    for budget in (120, 90):
        lua, ns, env, state = make_world(budget)
        frames, root_id = snapshot(ns, state)
        print(render(frames, root_id, f"session-{budget}", f"Session with {budget} available minutes; three unfinished 120-minute tasks.", digest))
        ns.window.chooseTask.Click(ns.window.chooseTask)
        frames, root_id = snapshot(ns, state)
        if budget == 120:
            print(render(frames, root_id, "choose-task", "Manual task picker; all unfinished tasks are available.", digest))
        ns.window.taskRows[3].choose.Click(ns.window.taskRows[3].choose)
        frames, root_id = snapshot(ns, state)
        print(render(frames, root_id, f"chosen-{budget}", f"Player-selected 120-minute task with {budget} available minutes; estimates remain unchanged.", digest))
        ns.window.showSuggestions.Click(ns.window.showSuggestions)
        if budget == 120:
            # The implementation may place management behind a separate tab.
            if ns.window.tasksTab is not None:
                ns.window.tasksTab.Click(ns.window.tasksTab)
            frames, root_id = snapshot(ns, state)
            print(render(frames, root_id, "tasks-list", "Unfinished task list with three fictional 120-minute dungeon tasks.", digest))
            for row in ns.window.taskRows.values():
                if row.task is not None and not row.task.completed:
                    row.edit.Click(row.edit)
                    break
            frames, root_id = snapshot(ns, state)
            print(render(frames, root_id, "task-editor", "Task editor opened for a fictional 120-minute dungeon task.", digest))
    if hashlib.sha256((ROOT / "SessionScout" / "UI.lua").read_bytes()).hexdigest() != digest:
        raise RuntimeError("UI.lua changed during rendering; regenerate previews from stable source")


if __name__ == "__main__":
    main()

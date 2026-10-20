# Try the task reminder

**Experimental: SessionScout 0.2.0-alpha.4 for WoW Forever 1.60.1.**
The default release remains [0.1.0](https://www.curseforge.com/wow/addons/sessionscout/files/9222143),
which does not include this tracker. No companion addon is needed for ordinary tasks.

Use a task you already intend to do. You do not need to invent a task, finish it
for this trial, or change how you normally play. Skipping the trial or finding
no benefit is useful feedback too.

## Install the experimental build

1. Download **SessionScout-0.2.0-alpha.4-forever.zip** from
   [its CurseForge file page](https://www.curseforge.com/wow/addons/sessionscout/files/9268483).
2. With WoW closed, back up your existing SessionScout addon folder and your
   Forever `WTF` folder, which contains saved settings. Extract the ZIP's
   `SessionScout` folder into your Forever `Interface/AddOns` folder; the current
   beta uses `_classic_beta_/Interface/AddOns`. The resulting path must contain
   `SessionScout/SessionScout.toc` directly. Keep your SavedVariables when updating.
3. Start WoW, enable SessionScout in the AddOns menu, and enter `/scout`.

Retail and other Classic flavors are unsupported. App-based installation is unverified.

## During your usual session

1. If your intended task is not saved, open **My tasks** → **+ New task**, enter
   its name and estimated minutes, and press **Add task**.
2. In **This session**, click **Choose myself** (or **Change task** if one is
   already chosen), then **Choose** beside your intended task. If that task is
   already chosen, keep it. You can choose a task longer than the selected time
   budget; the warning does not change it.
3. Close Scout. The compact tracker keeps the chosen task visible. Drag its
   background somewhere convenient if it overlaps other controls.
4. Play as usual. When your goal is actually reached, press **Done** on the
   tracker. **Undo** restores the task. **Choose next** opens the picker, or a
   new-task form if none remain; it never chooses a replacement automatically.

**Optional book task:** install and enable
[Librarian Books Forever](https://www.curseforge.com/wow/addons/librarian-forever)
separately. Edit your task, choose **Guide: Library books**, save and choose it.
**Book guide** opens Librarian's journal. Librarian supplies book progress;
opening it never completes your Scout task.

Alpha.4's timer has not been tested at an actual server reset. Chosen-task and
moved-position restoration after reload still need client verification.
See the [test record](TRACKER_TESTING.md) for scope and limitations.

## Tell us what happened

[Leave a short result](https://github.com/jdlarssen/SessionScout/issues/new?template=tracker_feedback.yml):
what you usually use to remember tasks, and what helped, got in the way or made
no difference. No later-use report is required. Omit names, chat and other personal
details; do not attach complete SavedVariables files.

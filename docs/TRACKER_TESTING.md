# Chosen-task tracker and book guide — 0.2.0-alpha.2

Experimental build for Forever 1.60.1, interface 16001.
The [GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.2.0-alpha.2-forever)
was published on 18 October 2026.
The new controls and optional companion interaction have not been tested in WoW.
The default public client-tested release remains 0.1.0.

![Source-derived tracker preview with a fictional library-book task](media/sessionscout-0.2.0-alpha.2-book-tracker-preview.png)

*Source-derived layout preview with a fictional task, not an in-game screenshot.
Fonts, wrapping and button textures are approximate. This shows Scout's optional
Book guide action, not Librarian's journal or detected collection progress.*

## Use

1. Choose an unfinished task and close Scout. A compact, movable tracker keeps
   its title visible. Drag the background to move it; the position is saved.
2. Use **Done** when your goal is reached. **Undo** restores and reselects that
   task. **Choose next** opens the picker, or a new-task form if none remain.
   No next task is chosen automatically. The completion card lasts only until
   dismissed or the UI is reloaded; completion itself remains saved.
3. For a library-book task, install and enable
   [Librarian Books Forever](https://www.curseforge.com/wow/addons/librarian-forever)
   separately. If WoW does not discover a new addon on reload, restart the client
   at a convenient time and check the AddOns list.
4. In Scout, edit the task, click **Guide: None** to select **Guide: Library books**,
   and save. Choose that task. **Book guide** is available on its card and tracker.
   The journal opens and Scout moves out of the way. This binding is per character.

Librarian supplies its own book catalogue, map markers and progress detection.
It uses quest completion and item counts, with manual corrections and some
unconfirmed mappings/locations. Check its displayed evidence when needed;
neither bag absence nor opening the guide proves a Scout task is complete.
Scout does not import checkmarks from a browser or infer a target from the task
name. A goal can be a subset of books or a reward tier; **Done** remains manual.

## Automated evidence

On 18 October 2026, 89 checks passed: 15 model, 55 mocked WoW integration and
19 Python tooling checks. Lua 5.1 syntax was checked. Coverage includes closing,
login/reload restoration, Done/Undo/next, unavailable reset times, missing identity,
future saved-data versions, explicit guide binding, cancel/unlink/delete, character
isolation, missing/malformed/failing companion and successful journal opening.
Source-derived HTML/SVG layouts are approximations, not client screenshots.

[Source CI](https://github.com/jdlarssen/SessionScout/actions/runs/39119703126)
passed for commit `68a53db955243a1ec7d60443e443f88451cfb6b7`. The 59,023-byte
release ZIP matches that commit's addon files and has SHA-256
`73c5dc86456ead1a957b44b8fdce1773f1b8aa75578cbc2423e3348ee6b28cde`.
GitHub's uploaded asset digest matches the local package. No verification download
was needed. These checks do not establish player adoption or client compatibility.

The integration targets the public `Librarian:OpenJournal()` entry point inspected
in [Librarian v1.3.0](https://github.com/thoriphes/Librarian/releases/tag/v1.3.0).
No Librarian code, data, assets or libraries are redistributed in SessionScout.

## Remaining client checks

- Choose an existing task, close Scout and verify that its tracker appears without
  covering essential controls. Drag it and check position after reload.
- Use Done, Undo and Choose next. Confirm the intended task changes and original
  estimates, priorities and other completions stay intact.
- Link a book task and open its journal from both the main window and tracker.
  Confirm journal controls are visible and its own book progress is meaningful.
- Verify missing/disabled Librarian gives a readable message and preserves the
  selected task. Check small UI scales, combat transitions and other characters.

Preserve saved data. Do not mark these client checks passed from mock results.

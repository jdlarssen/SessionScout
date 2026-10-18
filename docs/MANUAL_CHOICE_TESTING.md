# Manual task choice — 0.2.0-alpha.1

This experimental version lets the player override the automatic suggestions.
It targets Forever 1.60.1, interface 16001. The opt-in
[GitHub prerelease](https://github.com/jdlarssen/SessionScout/releases/tag/v0.2.0-alpha.1-forever)
was published on 18 October before client testing of its new controls.
Later scoped checks used alpha.2; see the [tracker test record](TRACKER_TESTING.md).
The default client-tested download remains 0.1.0. Back up existing saved data
and addon files before testing.

## Expected behavior

- **Choose** on a suggestion or unfinished task makes that task the current
  choice and returns to **This session**.
- **Choose myself** opens a list of all unfinished tasks. **Back** leaves the
  current choice unchanged. An existing editor draft remains available.
- **Change task** opens the same picker. **Use suggestions** clears the manual
  choice and returns to the existing budget-and-priority planner.
- Choosing does not mark a task complete, edit its estimate or priority, or
  change available time. A longer choice remains visible with an over-budget
  warning; it is not described as fitting the session.
- The choice is saved for the current character. Completing or deleting the
  chosen task clears it. A reset or Undo does not silently choose it again.

## Validation

On 18 October, **80 automated checks passed**: 15 pure model, 46 mocked
integration and 19 Python tooling checks. The workflow tests cover manual
selection, longer estimates, preset/custom/slash budgets, close/reload and
character isolation, stale choices, completion/deletion, parked drafts and
selection from a later page. Lua 5.1 syntax checks also passed.

Source-derived previews of the picker, selected task and task-management list
were visually checked. They use fictional tasks and approximate WoW fonts and
textures. No new-control in-client test had been completed at publication. These checks
do not establish game compatibility or usability.

## Short client check

1. After loading this version, enter `/scout`. Choose a suggested task with
   **Choose** and verify that **Your chosen task** names the selected task.
2. Open **Change task**, pick a different unfinished task, and verify the name.
   The task must remain unfinished and its estimate must stay unchanged.
3. Set an available time shorter than that task's estimate. Verify the choice
   stays visible and the time warning is correct. Restore the original budget.
4. Use **Use suggestions**. Verify that the automatic suggestions return.
5. Select a task, close/reopen the window, and later `/reload` at a convenient
   time. Verify that the choice persists. Clear it with **Use suggestions**
   if no task should remain selected.

Use temporary test tasks for completion/deletion checks. Preserve original
tasks, completion and reminders, and remove temporary tasks after testing.

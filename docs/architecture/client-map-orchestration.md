# Client Map Orchestration

The Godot client uses one reusable `World.tscn` as its composition root.
Map-specific content is supplied by a `MapDefinition`.

A map definition owns:

- map ID, display name, bounds, and default player spawn;
- an optional environment scene for terrain, buildings, and collision;
- NPC definitions and their local dialogue/quest references;
- monster spawn rules.

`MapCatalog` currently creates local map definitions. When map configuration
moves to the backend, the transport payload should contain stable IDs and
plain values. A client-side registry should resolve scene IDs such as
`village_elder` or `moon_slime` to trusted Godot `PackedScene` resources.
The backend should not send resource paths.

Runtime responsibilities are separated:

- `World.gd`: loads the map and wires systems together;
- `SpawnManager`: monster population and respawn lifecycle;
- `TargetingController`: target selection and range;
- `CombatController`: attacks, auto-attacks, and combat rewards;
- `QuestManager`: quest lifecycle and progress;
- `DialogController`: NPC interaction and quest dialogue.

Adding a map should primarily require a new map definition and, when needed,
an environment scene. Gameplay controllers should remain map-independent.

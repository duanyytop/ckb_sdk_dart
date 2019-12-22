// A script group is defined as scripts that share the same hash.
// A script group will only be executed once per transaction
class ScriptGroup {
  List<int> inputIndexes;

  ScriptGroup(this.inputIndexes);
}
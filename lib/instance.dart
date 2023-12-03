class InstanceManager {
  final Map<Object, int> _instancesToInstanceIds = {};
  final Map<int, Object> _instanceIdsToInstances = {};

  int _nextInstanceId = 0;

  static final InstanceManager instance = InstanceManager();

  int? tryAddInstance(Object instance) {
    if (_instancesToInstanceIds.containsKey(instance)) {
      return null;
    }
    _nextInstanceId++;
    _instancesToInstanceIds[instance] = _nextInstanceId;
    _instanceIdsToInstances[_nextInstanceId] = instance;
    return _nextInstanceId;
  }

  int? removeInstance(Object instance) {
    int? instanceId = _instancesToInstanceIds[instance];
    if (instanceId != null) {
      _instancesToInstanceIds.remove(instance);
      _instanceIdsToInstances.remove(instanceId);
    }

    return instanceId;
  }

  Object? getInstance(int instanceId) {
    return _instanceIdsToInstances[instanceId];
  }

  int? getInstanceId(Object instance) {
    return _instancesToInstanceIds[instance];
  }
}

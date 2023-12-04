package com.example.flutter_wangyan_webview

import androidx.collection.LongSparseArray

object InstanceManager {
    private val instanceIdsToInstances = LongSparseArray<Any>()
    private val instancesToInstanceIds = HashMap<Any, Long>()

    fun addInstance(instance: Any, instanceId: Long) {
        instancesToInstanceIds[instance] = instanceId;
        instanceIdsToInstances.append(instanceId, instance);
    }

    fun removeInstanceWithId(instanceId: Long): Any? {
        val instance = instanceIdsToInstances[instanceId]
        if (instance != null) {
            instanceIdsToInstances.remove(instanceId)
            instancesToInstanceIds.remove(instance)
        }
        return instance
    }

    fun removeInstance(instance: Any?): Long? {
        val instanceId = instancesToInstanceIds[instance]
        if (instanceId != null) {
            instanceIdsToInstances.remove(instanceId)
            instancesToInstanceIds.remove(instance)
        }
        return instanceId
    }

    fun getInstance(instanceId: Long): Any? {
        return instanceIdsToInstances[instanceId]
    }

    fun getInstanceId(instance: Any?): Long? {
        return instancesToInstanceIds[instance]
    }
}
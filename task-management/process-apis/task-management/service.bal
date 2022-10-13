import ballerina/http;
import task_management.impl;

listener http:Listener ep0 = new (9090, config = {host: "localhost"});

service /task/manage on ep0 {
    resource function post tasks(@http:Payload impl:TasksBody payload) returns impl:CreatedTask {
      return impl:createNewTask(payload);
    }
    resource function put tasks/[string taskId](@http:Payload impl:TasksTaskidBody payload) returns impl:Task|error {
      return impl:updateTask(taskId, payload);
    }
    resource function delete tasks/[string taskId]() returns http:Ok {
      return impl:deleteTask(taskId);
    }
    resource function post tasks/[string taskId]/'change\-group(@http:Payload impl:TaskidChangegroupBody payload) returns impl:InlineResponse200 {
      return impl:changeTaskGroup(taskId, payload);
    }
    resource function post tasks/[string taskId]/'change\-status(@http:Payload impl:TaskidChangestatusBody payload) returns impl:InlineResponse2001 {
      return impl:changeTaskStatus(taskId, payload);
    }
    resource function post groups(@http:Payload impl:GroupName payload) returns impl:CreatedGroup|error {
      return impl:createNewGroup(payload);
    }
    resource function put groups/[string groupId](@http:Payload impl:GroupName payload) returns impl:Group|error {
      return impl:updateGroup(groupId, payload);
    }
    resource function post archive/tasks(@http:Payload impl:ArchiveTasksBody payload) returns http:Ok {
      return impl:archiveTask(payload);
    }
    resource function post archive/groups(@http:Payload impl:ArchiveGroupsBody payload) returns http:Ok {
      return impl:archiveGroup(payload);
    }
}

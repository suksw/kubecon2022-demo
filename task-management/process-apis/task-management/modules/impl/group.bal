import task_management.api_group;

final api_group:Client groupClient = check new ({
    auth: {
        token: api_group:getToken()
    }
}, api_group:getUrl());

public isolated function createNewGroup(GroupName groupName) returns CreatedGroup|error {
    api_group:TaskgroupBody payload = {
        title: groupName.name,
        userId: extractUser("")
    };
    api_group:TaskGroup taskGroup = check groupClient->createTaskGroup(payload);
    return {
        body: {
            id: taskGroup.id,
            name: <string>taskGroup.title
        }
    };
}

public isolated function updateGroup(string groupId, GroupName groupName) returns Group|error {
    int id = check int:fromString(groupId);
    api_group:TaskgroupIdBody payload = {
        title: groupName.name
    };
    api_group:TaskGroup taskGroupById = check groupClient->updateTaskGroupById(id, payload);
    return {
        id: taskGroupById.id,
        name: <string>taskGroupById.title
    };
}

isolated function extractUser(string taskAppUserToken) returns string {
  return "user@gmail.com";
}

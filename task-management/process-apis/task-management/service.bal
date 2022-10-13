import ballerina/http;
import task_management.api_task;
import task_management.api_group;

listener http:Listener ep0 = new (9090, config = {host: "localhost"});

final api_task:Client taskClient = check new ({
    auth: {
        token: api_task:getToken()
    }
}, api_task:getUrl());

final api_group:Client groupClient = check new ({
    auth: {
        token: api_group:getToken()
    }
}, api_group:getUrl());

service /task/manage on ep0 {
    # Create new task
    resource function post tasks(@http:Payload TasksBody payload) returns CreatedTask|error {
        api_task:TaskBody taskBody = {
            title: payload.title,
            taskGroupId: payload.groupId
        };
        api_task:Task task = check taskClient->createTask(taskBody);
        return {
            body: {
                id: task.id,
                title: task.title,
                groupId: task.taskGroupId,
                status: task.taskStatus
            }
        };
    }

    # Update task
    resource function put tasks/[string taskId](@http:Payload TasksTaskidBody payload) returns Task|error {
        int id = check int:fromString(taskId);
        api_task:Task taskById = check taskClient->getTaskById(id);

        api_task:TaskIdBody taskIdBody = {
            title: payload.title,
            taskGroupId: taskById.taskGroupId,
            taskStatus: taskById.taskStatus
        };
        api_task:Task taskByIdResult = check taskClient->updateTaskById(id, taskIdBody);
        return {
            id: taskByIdResult.id,
            title: taskByIdResult.title,
            groupId: taskByIdResult.taskGroupId,
            status: taskByIdResult.taskStatus
        };
    }

    # Delete task
    resource function delete tasks/[string taskId]() returns http:Ok|error {
        int id = check int:fromString(taskId);
        api_task:Task taskById = check taskClient->deleteTaskById(id);
        return http:OK;
    }

    # Change task group
    resource function post tasks/[string taskId]/'change\-group(@http:Payload TaskidChangegroupBody payload)
        returns InlineResponse200|ConflictMessage|error {

        int id = check int:fromString(taskId);
        api_task:Task taskById = check taskClient->getTaskById(id);
        if (payload.groupId != taskById.taskGroupId) {
            ConflictMessage errorMsg = {
                body: {
                    message: "The task to be updated does not belong to the group provided"
                }
            };
            return errorMsg;
        }

        api_task:TaskIdBody taskIdBody = {
            title: taskById.title,
            taskGroupId: payload.newGroupId,
            taskStatus: taskById.taskStatus
        };
        api_task:Task taskByIdResult = check taskClient->updateTaskById(id, taskIdBody);
        return {
            groupId: taskByIdResult.taskGroupId
        };
    }

    # Change task status
    resource function post tasks/[string taskId]/'change\-status(@http:Payload TaskidChangestatusBody payload) returns InlineResponse2001|ConflictMessage|error {
        int id = check int:fromString(taskId);
        api_task:Task taskById = check taskClient->getTaskById(id);
        if (payload.status == taskById.taskStatus) {
            ConflictMessage errorMsg = {
                body: {
                    message: "The task is already in the provided status"
                }
            };
            return errorMsg;
        }

        api_task:TaskIdBody taskIdBody = {
            title: taskById.title,
            taskGroupId: taskById.taskGroupId,
            taskStatus: payload.status
        };
        api_task:Task taskByIdResult = check taskClient->updateTaskById(id, taskIdBody);
        return {
            status: taskByIdResult.taskStatus
        };
    }

    # Create group
    resource function post groups(@http:Payload GroupName payload) returns CreatedGroup|error {
        api_group:TaskgroupBody taskgroupBody = {
            title: payload.name,
            userId: extractUser("")
        };
        api_group:TaskGroup taskGroup = check groupClient->createTaskGroup(taskgroupBody);
        return {
            body: {
                id: taskGroup.id,
                name: <string>taskGroup.title
            }
        };
    }

    # Update group
    resource function put groups/[string groupId](@http:Payload GroupName payload) returns Group|error {
        int id = check int:fromString(groupId);
        api_group:TaskgroupIdBody taskgroupIdBody = {
            title: payload.name
        };
        api_group:TaskGroup taskGroupById = check groupClient->updateTaskGroupById(id, taskgroupIdBody);
        return {
            id: taskGroupById.id,
            name: <string>taskGroupById.title
        };
    }

    # Archive task
    resource function post archive/tasks(@http:Payload ArchiveTasksBody payload) returns http:Ok {
        return http:OK;
    }

    # Archive task
    resource function post archive/groups(@http:Payload ArchiveGroupsBody payload) returns http:Ok {
        return http:OK;
    }
}

isolated function extractUser(string taskAppUserToken) returns string {
    return "user@gmail.com";
}

public type CreatedGroup record {|
    *http:Created;
    Group body;
|};

public type CreatedTask record {|
    *http:Created;
    Task body;
|};

public type GroupName record {
    string name;
};

public type Group record {
    int id?;
    string name?;
};

public type Task record {
    int id?;
    string title?;
    string status?;
    int groupId?;
};

public type ArchiveTasksBody record {
    int groupId;
    int taskId;
};

public type ArchiveGroupsBody record {
    int groupId;
};

public type TasksTaskidBody record {
    string title;
};

public type InlineResponse2001 record {
    string status?;
};

public type InlineResponse200 record {
    int groupId?;
};

public type TasksBody record {
    int groupId;
    string title;
};

public type TaskidChangegroupBody record {
    int groupId;
    int newGroupId;
};

public type TaskidChangestatusBody record {
    string status;
};

public type ConflictMessage record {|
    *http:Conflict;
    Message body;
|};

public type Message record {
    string message?;
};

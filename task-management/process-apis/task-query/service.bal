import ballerina/graphql;

// The API is exposed at `http://localhost:4000/task/query`.
service /task/query on new graphql:Listener(4000) {

    # Returns all groups including the task list per each group
    # + return - All groups
    resource isolated function get groups() returns Group[] {
        table<Task> key(id) tasksTable = table [];

        json rawTasks = getAllTasks();
        Task[] tasksArr = <Task[]>rawTasks;

        foreach Task task in tasksArr {
            tasksTable.add(task);
        }

        json rawGroups = getAllGroups();
        GroupEntity[] groups = <GroupEntity[]>rawGroups;

        Group[] groupArray = [];
        foreach GroupEntity group in groups {
            Task[] tasks = from Task task in tasksArr
                where task.groupId == group.id
                select task;

            Group groupWithTasks = {
                id: group.id,
                name: group.name,
                tasks: tasks
            };

            groupArray.push(groupWithTasks);
        }
        return groupArray;
    }
}

public type Group record {|
    int id;
    string name;
    Task[] tasks;
|};

public type Task record {|
    int groupId;
    readonly int id;
    string title;
    string status;
    string createdAt;
    string updatedAt;
|};

type GroupEntity record {|
    int id;
    string name;
|};

//--------- Methods to call entity APIs

public isolated function getAllGroups() returns json {
    GroupEntity[] groups = [
        {
            id: 1,
            name: "Urgent and Important"
        },
        {
            id: 2,
            name: "Urgent, not important"
        },
        {
            id: 3,
            name: "Important, not urgent"
        },
        {
            id: 4,
            name: "Not urgent and not important"
        }
    ];

    return groups;
}

public isolated function getAllTasks() returns json {
    Task[] tasks = [];
    foreach int i in 0 ... 4 {
        Task[] tasksTemp = genTaskForGroup(i, 8);
        tasks.push(...tasksTemp);
    }

    return tasks;
}

// temp methods to simulate entity API
isolated function genTaskForGroup(int groupId, int numberOfTasks) returns Task[] {
    Task[] tasks = [];
    string[] states = ["open", "in-progress", "complete"];
    foreach int i in 0 ... numberOfTasks - 1 {
        int taskId = (groupId * numberOfTasks) + i;
        string title = "Task " + taskId.toString();
        Task task = {
            groupId,
            id: taskId,
            title: title,
            status: states[i % 3],
            createdAt: "t1",
            updatedAt: "t2"
        };
        tasks.push(task);
    }
    return tasks;
}


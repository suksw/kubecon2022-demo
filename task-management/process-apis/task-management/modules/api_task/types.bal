import ballerina/constraint;

public type TaskArr Task[];

public type Task record {
    @constraint:Int {minValue: 1}
    int id;
    string title;
    @constraint:Int {minValue: 1}
    int taskGroupId;
    string taskStatus;
    string createdAt;
    string updatedAt;
};

public type TaskBody record {
    string title?;
    string taskStatus?;
    int taskGroupId?;
};

public type TaskIdBody record {
    string title?;
    string taskStatus?;
    int taskGroupId?;
};

public type TaskStatus record {
    @constraint:Int {minValue: 1}
    int id;
    string name;
    string userId;
    string createdAt;
    string updatedAt;
};

public type TaskGroup record {
    @constraint:Int {minValue: 1}
    int id;
    string title;
    string userId;
    string createdAt;
    string updatedAt;
};

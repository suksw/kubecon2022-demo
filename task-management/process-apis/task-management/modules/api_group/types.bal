import ballerina/constraint;

public type TaskGroupArr TaskGroup[];

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

public type TaskgroupBody record {
    string title?;
    string userId?;
};

public type TaskgroupIdBody record {
    string title?;
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

package Logging is

  type Method_Enum is (
    Initialize,
    Adjust,
    Finalize,
    Enqueue_Datablock,
    Dequeue_Datablock
    );

  procedure Log (Method : Method_Enum; Message : String);

end Logging;

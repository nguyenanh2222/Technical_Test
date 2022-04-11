select attendence, 
    count(nullif(absent_flag = false, true)),  -- count true values
    count(nullif(absent_flag, true)),   -- count false values
    count(student_id);
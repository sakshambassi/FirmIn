delimiter //

create trigger approveteam
after update on project_info
for each row
begin
if(new.status = 'completed')
then

update employee_info set team_id = 0 where team_id in(select team_id from project_info where project_id = new.project_id) and emp_id not in(select teamleader_id from team_info where team_id in (select team_id from project_info where project_id = new.project_id));

end if;

end//
delimiter ;

delimiter //

create trigger aptrig
after update on project_info
for each row
begin
if(new.status = 'completed')
then

update team_task set status = 'Finished' where project_id = new.project_id;

end if;

end//
delimiter ;

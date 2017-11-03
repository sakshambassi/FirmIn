 delimiter //
create procedure total_salary()
begin 
update employee_conduct set employee_salary=((base_salary+employee_DA+employee_HRA)-((professional_tax/100)*base_salary)-((providend_fund/100)*base_salary)); 
end //
delimiter ;




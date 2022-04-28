-- Code showing average salaries by offices 

select office_id, o.address, avg(salary) AS AverageSalary
from employees e
join offices o USING (office_id)
group by office_id, o.address
ORDER BY office_id


-- Code to show how well employees earn in their respective offices
-- High earners : if the salary is greater than the average salary of that office
-- Low earners :  if the salary is lower than the average salary of that office
-- Average earners: if the salary is exactly equal to the average salary of that office

select 
	concat(first_name, ' ', last_name) AS FullName, 
    office_id, 
    o.address AS OfficeAddress, 
    salary, 
    CASE
		when salary > (select avg(salary) from employees e where e.office_id = em.office_id) then 'High Earner'
        when salary < (select avg(salary) from employees e where e.office_id = em.office_id) then 'Low Earner'
		else 'Average Earner'
    END AS SalaryStatus
from employees em
join offices o USING (office_id)    
order by office_id


-- code showing full name of employees and their respective supervisor's full name Using a SELF JOIN

select 
	concat(e.first_name, ' ',e.last_name) AS Employee_FullName , 
    concat(em.first_name, ' ', em.last_name) AS Supervisor
from employees e
left join employees em ON e.reports_to = em.employee_id




Use sakila ;

# 1.a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;


#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(concat(first_name," "),last_name)) as "Actor Name" from actor

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know 
# only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name  from actor
where first_name = 'Joe'


#2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name  from actor
where last_name like '%GEN%'


#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name  from actor
where last_name like '%LI%'
order by last_name, first_name

#2. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh','China')


#3a. You want to keep a description of each actor. You don't think you will be performing queries on 
#a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research 
#the type BLOB, as the difference between it and VARCHAR are significant).


#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.


#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(actor_id) "Count of Actors" from actor group by last_name

#4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors.
select last_name, count(actor_id) "Count of Actors" from actor group by last_name having count(actor_id) >1

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor where first_name ='GROUCHO' and last_name ='WILLIAMS'
update actor 
set first_name = HARPO 
where actor_id =172
commit;
select * from actor where actor_id =172

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.


#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
create table CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;


#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff_id, first_name, last_name , address, address2 , postal_code, location , city_id 
from staff join address on address.address_id = staff.address_id


#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select  staff.staff_id , sum(amount) 
from payment join staff on payment.staff_id= staff.staff_id
where payment_date between '2005-08-01' and '2005-08-31'
group by staff.staff_id


#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.film_id, title, count(actor_id) "Count_of_Actors" 
from film join film_actor on film.film_id = film_actor.film_id
group by film.film_id, title

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) "No of Copies" 
from inventory 
where film_id in (select film_id from film where title like "Hunchback%")


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name:
Select customer.customer_id, first_name, last_name, sum(amount) "Payment Amt" from
customer join payment on customer.customer_id=payment.customer_id 
group by customer.customer_id, first_name, last_name
order by last_name


##7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of 
#movies starting with the letters K and Q whose language is English.
select title from film 
where title like "K%" or title like "Q%"
and language_id in ( select language_id from language where name ='English')



#7b. Use subqueries to display all actors who appear in the film Alone Trip.

select actor_id, first_name, last_name from actor 
where actor_id in ( select actor_id from film_actor join film on film.film_id = film_actor.film_id and film.title = 'Alone Trip')

#7c. You want to run an email marketing campaign in Canada, for which you will need the names 
#and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer_id, first_name, last_name, email from 
customer join address on customer.address_id = address.address_id 
join city on city.city_id = address.city_id
join country on city.country_id = country.country_id
where country.country = 'Canada' 


#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as family films.
select film.film_id, title, category.name from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name = 'Family'


#7e. Display the most frequently rented movies in descending order.
select  inventory.film_id, film.title, count(rental_id) "Count of Rentals" 
from rental 
join inventory on rental.inventory_id= inventory.inventory_id
join film on inventory.film_id = film.film_id 
group by inventory.film_id, film.title
order by count(rental_id) desc


#7f. Write a query to display how much business, in dollars, each store brought in.



#7g. Write a query to display for each store its store ID, city, and country.
#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
#8b. How would you display the view that you created in 8a?
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.





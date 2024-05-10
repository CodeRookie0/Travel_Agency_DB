# Travel-Agency-DB
Welcome to the Travel Agency Database! This project is designed to facilitate travel management processes for a travel agency, providing comprehensive tools for planning, booking, and monitoring trips.
# Table of Content
* [General info](#general-info)
* [Technologies](#technologies)
* [ER Diagram](#er-diagram)
* [Functional requirements](#functional-requirements)
* [Non-functional requirements](#non-functional-requirements)
* [Content Overview](#content-overview)
* [Additional info](#additional-info)
* [Planned changes](#planned-changes)
* [Author](#author)
  
## General info:
The "Travel Agency" database is a key tool in organizing customer travel by a travel agency. It provides comprehensive data management necessary for planning, booking and monitoring trips.

## Technologies:
* ![SQL](https://img.shields.io/badge/-SQL-4479A1?style=flat&logo=sql&logoColor=white)
* ![MS SQL Server](https://img.shields.io/badge/-MS%20SQL%20Server-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)

## ER Diagram:
![ER Diagram](./Documentation%20files/ER%20Diagram%20for%20DB_2%20%5B.png%5D.png)

## Functional requirements
### :world_map: Trip data management:
- Add, edit, and delete continents, countries, cities, bus routes, flights, hotels, and travel packages.
- View information about available routes, flights, hotels, and travel packages.
- Search for travel packages based on various criteria such as country, continent, city, and price.
### :chart_with_upwards_trend: Package Details Calculation:
- Automatically calculate and update package details (start date, end date, duration, price) based on associated hotel, flight, and bus route data.
### :tickets: Reservations:
- Allow customers to book travel packages.
- Enable customers to view their reservations and transaction history.
- Allow travel agency employees to manage reservations (add, edit, delete).
### :money_with_wings: Booking price update:
- Calculate and update reservation prices for specific packages based on provided percentage discounts.
### :busts_in_silhouette: User management:
- Enable system administrators to manage users, assign roles, and enforce access permissions.
### :bar_chart: Generating reports:
- Generate revenue reports based on travel package bookings.
- Generate popularity reports showing booking frequency for each package.
- Generate detailed booking reports for analysis.
  
## Non-functional requirements:
### :hourglass_flowing_sand: Efficiency:
- Ensure the system is responsive with minimal response times, even when handling large datasets.
### :lock: Security:
- Store customer personal data securely in compliance with data protection regulations.
- Implement user authentication and authorization mechanisms to control data access.
### :globe_with_meridians: Availability:
- Maintain system availability with minimal downtime, including regular data backups for disaster recovery.
### :rocket: Scalability:
- Design the system to scale efficiently as the user base and data volume grow.
### :computer: User Interface:
- Create an intuitive and user-friendly interface adaptable to various devices.
### :notebook_with_decorative_cover: Documentation:
- Maintain up-to-date system documentation including functional descriptions, operating instructions, and maintenance procedures.
  
## Content Overview
The database contains information about customers, including personal data, contacts and addresses, which facilitates identification and communication. Additionally, data on continents, countries and cities enable you to choose the right travel destination.

Information about hotels, flights, guides, drivers and buses is crucial to putting together comprehensive travel packages. They allow you to choose the best accommodation options, flight routes and transport between destinations.

Travel bookings are tracked in a separate table, making it easy to manage them and monitor your customers' travel history. This allows the agency to tailor its offer to customer preferences, ensuring high quality of services and customer satisfaction, which in turn translates into an increase in income.


## Additional info:<br>
This project is not commercial. The main goal of "Travel Agency Database" is to learn
- Developing, implementing and programming a server-side database in an environment
MS SQL Server
- Development of design documentation

## Planned changes:
This project is **at the development stage** and has not been completed. I am planning to 
- Add an archive table
- Add system users divided into users, administrator, office employee, etc., assigning appropriate permissions
- Expanding tables such as tbl_hotel or tbl_package to include hotel availability, different room types, and time available to register for travel. 
- Add additional attractions in the city travel
- Add additional procedures and functions for greater database functionality
- Create a dekstop application after searching for travel using the presented database
## Author:<br>
Maryia Shyliankova

**Last update: 10/05/2024**

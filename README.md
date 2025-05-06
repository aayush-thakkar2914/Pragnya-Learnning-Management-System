# Pragnya Learning Management System

Pragnya LMS is a Java-based web application designed to facilitate efficient online learning and course management. It supports two types of users: **Students** and **Instructors**, offering course enrollment, material management, feedback, and progress tracking features.

## 📁 Project Structure

Pragnya-Learnning-Management-System
├── src/
│ ├── main/
│ │ ├── java/com/lms/controllers/ # Servlet controllers
│ │ ├── java/com/lms/dao/ # Data Access Objects
│ │ ├── java/com/lms/models/ # Entity classes
│ │ ├── java/com/lms/utils/ # Utility (e.g., DB connection)
│ │ └── webapp/
│ │ ├── assets/ # Static assets (CSS/JS/images)
│ │ ├── WEB-INF/ # web.xml config
│ │ └── JSP pages # UI JSPs for various roles
├── LMSproject.sql # Oracle DB schema
├── pom.xml # Maven dependencies
├── .project / .classpath / .settings # Eclipse project files
└── target/ # Compiled output


## ✨ Features

- 👨‍🎓 Student & 👩‍🏫 Instructor Roles
- 🔐 Signup & Login Authentication
- 📚 Course Upload & Enrollment
- ✅ Mark Material as Completed
- 📊 Progress Tracking with Progress Bar
- 📝 Feedback Submission System
- 📂 View Enrolled Students (for instructors)

## 🛠️ Technologies Used

- **Backend:** Java Servlets
- **Frontend:** JSP, HTML, Tailwind CSS
- **Database:** Oracle SQL
- **Build Tool:** Maven
- **IDE:** Eclipse
- **JDBC:** For DB operations

## 🧱 Database Schema

- Users Table (Instructor / Student)
- Courses, Materials, Enrollments
- Feedback and Progress Tracking Tables

Import `LMSproject.sql` into your Oracle SQL Developer to create the schema.

## 🚀 How to Run

1. Clone the repository:
   
  gh repo clone aayush-thakkar2914/Pragnya-Learnning-Management-System

2.  Import it into Eclipse IDE as a Maven Project.

3. Set up Oracle Database and import LMSproject.sql.

4. Configure database credentials in DatabaseConnection.java.

5. Deploy to a server like Apache Tomcat.

6. Run the project on the server.

📸 Screenshots

![image](https://github.com/user-attachments/assets/953da12e-5f62-4226-a3ca-6402d89f34c4)

![image](https://github.com/user-attachments/assets/5a9c40a7-7b2e-4e27-8b47-6b7ba6ccb60b)

![image](https://github.com/user-attachments/assets/00bc90ae-b793-41e7-b43d-998cb3d6637f)

![image](https://github.com/user-attachments/assets/3fa2a204-3737-443c-abc4-a8f5e4c45b8b)

![image](https://github.com/user-attachments/assets/2513ff4f-4a72-4fbe-b791-0e3fa1420c14)

![image](https://github.com/user-attachments/assets/dd20e765-9fc5-4e69-8a2d-cb1e39c0cad9)

![image](https://github.com/user-attachments/assets/a663641d-09d1-405c-84fd-7fcc654a3e25)

![image](https://github.com/user-attachments/assets/46840b20-5908-4654-860d-85c89528a7e6)

![image](https://github.com/user-attachments/assets/eda0b8b2-eb39-4fd5-8aab-65cc5ae495df)

![image](https://github.com/user-attachments/assets/ca7e2584-008c-4691-ba82-141cbbbf19a3)





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
   ```bash
   git clone https://github.com/your-username/Pragnya-LMS.git

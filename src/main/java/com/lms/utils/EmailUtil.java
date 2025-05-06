package com.lms.utils;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {
    
    public static boolean sendEmail(String to, String subject, String body) {
        final String fromEmail = "your_email_address"; 
        final String password = "your_app_password"; 

        // 1️⃣ Set Mail Server Properties
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // 🔹 Fix SSL issues
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // 🔹 Fix SSL certificate errors

        // 2️⃣ Create a Mail Session with Authentication
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        session.setDebug(true); // ✅ Enable debugging logs

        try {
            // 3️⃣ Create Email Message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);

            // 4️⃣ Send Email
            Transport transport = session.getTransport("smtp");
            transport.connect("smtp.gmail.com", fromEmail, password);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close(); // ✅ Close connection

            System.out.println("✅ Email sent successfully to: " + to);
            return true;

        } catch (Exception e) {
            System.out.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}


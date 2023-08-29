# Implementation & my learnings from this project

1. **Setting Up the Project**:
   I began by creating a new Flutter project using my preferred IDE and set up a well-organized directory structure for different app components.

2. **Integrating Firebase**:
   I connected my app to the Firebase project I had established on the Firebase Console. This involved configuring services like Firestore and authentication.

3. **Handling Authentication**:
   I implemented user authentication using the `firebase_auth` package. Users were able to sign up, log in, and manage their accounts.

4. **Utilizing Firestore for Data**:
   Integrating the `cloud_firestore` package, I interacted with the Firestore database. I designed collections and documents to store user data, expenses, subscriptions, and more.

5. **Managing User Profiles**:
   I developed screens that allowed users to manage their profiles, including updating personal information and profile pictures.

6. **Managing Income Sources**:
   I created screens that enabled users to input and manage their income sources. Income was automatically deposited into the user's account each month.

7. **Tracking Expenses**:
   My app included screens where users could effortlessly add, edit, and delete expenses. I set up Firestore listeners to instantly update the database when any expense changes occurred.

8. **Visualizing Expense Trends**:
   I crafted screens that displayed charts and graphs illustrating how expenses were distributed over time. To create pie charts and other visual aids, I used the `charts_flutter` package.

9. **Handling Subscriptions**:
   I implemented a feature to manage subscriptions, encompassing actions like addition, modification, and cancellation. For automatic subscription deductions, I leveraged Firebase Cloud Functions.

10. **Setting Budget Limits**:
    I designed screens that empowered users to establish budget limits for different expense categories. My app provided notifications when users exceeded their set limits.

11. **Managing Dues**:
    I created screens where users could monitor outstanding payments and amounts owed to them.

12. **Designing User Interfaces**:
    I ensured the user interfaces across all screens were intuitive and user-friendly, maintaining a consistent look and feel using Flutter widgets and styles.


In this process I learnt how to efficiently interact with user data stored on an online database through a Flutter app. Towards the end I was well-versed with the methods of setting
up streams to retrieve data from the database. I was also able to make an interactive interface for the user. 

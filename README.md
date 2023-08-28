# PennySaver Expense Management App
**PennySaver App keeps track of the expenses, budgets, subscriptions etc., thus helping the user manage his money better and increase his/her savings.**

## Origin of idea
Monitoring our expenditures during college has consistently posed a challenge due to our inclination to exceed our budgets. This predicament isn't limited to students; it extends to a significant portion of the employed populace. Even in domestic settings, managing expenses presents difficulties. This underscores the need for a remedy that motivates individuals to meticulously observe their daily financial outlays and effectively allocate funds to amplify their savings.

## Installations
1. **Flutter SDK**: The Flutter software development kit is the foundation for building the app.
2. **Firebase Tools**: Firebase provides backend services, including Firestore for the database.
3. **Flutter Packages**:
   Dependencies to be added in *pubspec.yaml* file:
      cupertino_icons: ^1.0.2,
      firebase_auth: ^4.8.0,
      cloud_firestore: ^4.9.0,
      firebase_core: ^2.15.1,
      provider: ^6.0.5,
      flutter_spinkit: ^5.2.0,
      intl: ^0.18.1,
      fl_chart: ^0.63.0,
      syncfusion_flutter_gauges: ^22.2.10

4. **Android Studio / Visual Studio Code**:
   These are popular IDEs for Flutter development. You can choose either one based on your preference.
6. **Android Emulator**:
   For testing your app, you'll need emulators or simulators to run the app on virtual devices.


## Objectives
1. Constructing an application for retaining the user's account particulars.
2. Monitoring their earnings and initiating deposits into the relevant bank account at the start of each month.
3. Enabling users to revise their day-to-day expenditures and utilizing this information to produce a categorized pie chart representing these costs.
4. Additional functionalities encompass subscriptions, budgeting, and outstanding payments.

## Using the app/Features
1. Access the app by logging in using a valid email address and password. New users will need to complete a registration process.
2. During the signup process, users will provide essential information such as a chosen username, email address, password, details of their primary bank account, and the income associated with that account.
3. Upon logging in, users can store and edit information related to their bank accounts and income sources whenever necessary.
4. Users can also input new expenses, including amount, account, category, and reason. These details can later be utilized to create a pie chart illustrating expense distribution over a specific time frame.
5. Additionally, users have the ability to include new subscriptions for managing regular payments, such as subscriptions for services like Spotify or Netflix, as well as routine groceries. These payments will be automatically deducted after the designated interval.
6. The app features a budgeting functionality that empowers users to set spending limits for specific categories. Notifications are sent if these limits are exceeded.
7. Users can conveniently monitor outstanding payments or amounts to be collected. This function proves especially beneficial for keeping track of financial obligations that might otherwise be overlooked.

## Implementation
The app has been created using the **Flutter** framework and **Firestore(Firebase)** database. Every aspect, ranging from authentication to pending payments, is stored within a Firestore database and accessed through streams that are established via Flutter.

## Challenges
1. **Data Security and Privacy:** Ensuring that user account details, income information, and expenses are stored securely in the Firestore database and that appropriate authentication and authorization measures are in place to safeguard sensitive information.

2. **Database Structure:** Designing an efficient database structure in Firestore that accommodates various user data, such as account details, incomes, expenses, subscriptions, budgets, and dues, while maintaining a balance between data normalization and performance.

3. **Real-time Updates:** Implementing real-time updates through Flutter streams to reflect changes in data, such as expenses and account balances, in real-time for the user.

4. **Pie Chart Generation:** Developing a mechanism to accurately generate pie charts based on the user's categorized expenses, ensuring that the chart data is correctly extracted and displayed.

5. **Automated Deposits:** Creating a reliable process for automatically depositing the specified amount into the user's bank account at the beginning of each month, with proper error handling and verification.

6. **Expense Categorization:** Designing an intuitive user interface that allows for easy input and categorization of daily expenses, and handling scenarios where expenses might not fit neatly into predefined categories.

7. **Subscription Management:** Implementing a system for managing subscriptions and handling automatic deductions at specified intervals, while accounting for potential issues like payment failures and account changes.

8. **Budgeting Logic:** Developing a functional and user-friendly budgeting feature that enables users to set spending limits for different categories and receive notifications when those limits are exceeded.

9. **User Experience:** Ensuring a seamless and intuitive user experience across various screens, from account setup and expense tracking to generating reports and managing subscriptions.

## Future Scope
1. **Expense Analytics**: Provide detailed insights into spending patterns, trends, and comparisons over different time periods.
2. **Bill Reminders**: Set up automated reminders for upcoming bill payments and deadlines.
3. **Customizable Categories**: Allow users to create personalized spending categories for better expense tracking.
4. **Currency Conversion**: Incorporate real-time currency conversion for users who frequently deal with multiple currencies.
5. **Integration with Banks**: Enable direct integration with banks for automatic transaction updates and account syncing.

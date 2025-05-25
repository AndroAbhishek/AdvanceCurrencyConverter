# 💱 Advanced Currency Converter App

A Flutter-based **Advanced Currency Converter** application that allows users to input amounts in multiple currencies, calculate their total value, and provide a **normalized sum in a selected base currency** using **real-time exchange rates**.

## 📸 Screen Recording
Watch the demo (https://www.youtube.com/watch?v=yQNL8LmdUqY)

## ✨ Features

### 🔹 Main Screen
- Add multiple currency input fields via an **“Add Currency”** button.
- Enter amounts and select currencies using a dropdown or search functionality.
- Calculate the total normalized value using a **“Calculate Total”** button.
- View results in a base currency selected by the user.

### 🔹 Settings Screen
- Choose the **base currency** for normalization.

### 🔹 Currencies List Screen
- Display a list of available currencies with their codes and names.

## ⚙️ Functionality

- Fetch **real-time exchange rates** using a reliable API (e.g., [ExchangeRate-API](https://apilayer.com/marketplace/exchangerates_data-api)).
- Accept multiple currency amounts as input and convert each to the selected base currency.
- Show the **total normalized value**.
- Handle errors gracefully.

## 🧱 Technical Specifications

- **Framework:** Flutter
- **Architecture:** MVVM
- **State Management:** Riverpod
- **Platforms:** Android & iOS
- **UI:** Responsive across different screen sizes and orientations
- **Currencies Supported:** 150+

## 🧪 Testing

- Includes **unit tests** for:
  - Fetching exchange rates
  - Currency conversion logic
  - Total calculation
- Achieves **full code coverage** on ViewModels and Repositories

## 🚀 Performance & Optimization

- Optimized for minimal API call delays and quick UI rendering.
- **Local caching** of exchange rates using [Floor](https://pub.dev/packages/floor) for offline access and reduced API calls.
- **Offline Mode**: Works without an internet connection if local data is available.
- Local storage powered by **Floor database**.

---

## 📸 Screenshots

![Image](https://github.com/user-attachments/assets/6ce99513-32cf-413a-a0f5-848ca83b870f)
![Image](https://github.com/user-attachments/assets/955033a8-7bef-4aff-8134-5df9c07d6153)
![Image](https://github.com/user-attachments/assets/cd3ab51f-d9b7-435d-9ca7-7e9807031ad2)
![Image](https://github.com/user-attachments/assets/ff37cdb2-9a87-4670-85c1-a02e2ad91780)

---

## 🧑‍💻 Developer Setup

### 🔧 Requirements
- Flutter SDK
- Dart
- Android Studio / Xcode
- Visual Studio Code



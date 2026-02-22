# Field Visit Logging Mobile App

A Flutter-based mobile application that allows Field Executives to record farm visits efficiently — even without internet connectivity.

The application follows an **offline-first approach** using Sqflite for local data persistence and automatic synchronization when internet becomes available.

---

##  Objective

This app demonstrates:

- Flutter UI Development
- Camera Integration
- GPS Location Capture
- Offline-first Architecture
- Local Data Persistence using Sqflite
- API Synchronization
- MVVM Architecture with Provider

---

##  Architecture

The application follows **MVVM Architecture** with clear separation of concerns:

---

##  Tech Stack

- Flutter
- Provider (State Management)
- Sqflite (Local Database)
- Path Provider
- Image Picker (Camera)
- Geolocator (GPS)
- Connectivity Plus (Internet Detection)
- REST API (Mock/Firebase)

---

##  Local Database Design (Sqflite)

Table: `visits`

| Column Name   | Type     | Description |
|--------------|----------|-------------|
| id           | INTEGER  | Primary Key |
| farmerName   | TEXT     | Farmer name |
| village      | TEXT     | Village name |
| cropType     | TEXT     | Crop details |
| notes        | TEXT     | Optional notes |
| imagePath    | TEXT     | Stored image path |
| latitude     | REAL     | GPS Latitude |
| longitude    | REAL     | GPS Longitude |
| visitDate    | TEXT     | DateTime |
| isSynced     | INTEGER  | 0 = Pending, 1 = Synced |

---

##  Features

###  Login Screen
- Username & Password validation
- Required field validation
- Navigation to Visit List screen

---

###  Visit List Screen
Displays:
- Farmer Name
- Village
- Crop Type
- Visit Date
- Visit Photo Thumbnail
- Sync Status (Synced / Pending)

---

###  Add New Visit
User inputs:
- Farmer Name
- Village
- Crop Type
- Notes (Optional)

App auto-captures:
- Current Date & Time
- GPS Coordinates
- Camera Image

Data saved locally in Sqflite database.

---

###  Offline-First Behaviour

If Internet is NOT available:
- Visit saved locally
- isSynced = 0 (Pending)

When Internet becomes available:
- App checks pending visits
- Uploads to API
- On success → isSynced = 1
- Updates local database

---

##  Sync Flow

1. Insert visit into Sqflite with isSynced = 0
2. Listen for connectivity changes
3. Fetch unsynced visits
4. Send to API
5. If success → Update record to isSynced = 1

---

# Age Verification Feature - Malaysia Driving Age Requirement

## Overview

Added age verification to ensure all users (owners and guests) meet Malaysia's minimum driving age requirement of **18 years** before accessing the vehicle.

## Implementation Details

### 1. RegisteredKad Model Updates (`lib/models/registered_kad.dart`)

#### New Fields & Properties:

- **`dateOfBirth`**: DateTime field extracted from MyKAD number
- **`age`**: Computed property that calculates current age
- **`isEligibleToDrive`**: Boolean getter that returns `true` if age >= 18

#### New Static Method:

```dart
static DateTime? extractDateOfBirth(String kadNumber)
```

Extracts date of birth from Malaysian MyKAD number format: `YYMMDD-PP-NNNN`

- Example: `950123-01-5678` = Born 23 January 1995
- Handles century detection (1900s vs 2000s based on current year)

### 2. CarProvider Updates (`lib/providers/car_provider.dart`)

#### Modified `registerKad()` Method:

- Now extracts date of birth from MyKAD number during registration
- Throws exception if MyKAD format is invalid
- Automatically includes dateOfBirth in RegisteredKad object

### 3. Lock Screen Updates (`lib/screens/lock_screen.dart`)

#### Age Verification Flow:

All authentication paths now include age verification:

1. **Owner Registration** (`_registerNewOwner`)

   - Scans MyKAD → Extracts DOB → Calculates age
   - If age < 18: Shows error dialog and denies access
   - If age >= 18: Shows age in verification message, proceeds with registration

2. **New Guest Access** (`_verifyNewGuest`)

   - Scans MyKAD → Extracts DOB → Calculates age
   - If age < 18: Shows error dialog and denies access
   - If age >= 18: Shows age in verification message, grants temporary access

3. **Returning Guest Access** (`_verifyReturningGuest`)
   - Re-verifies age on each access attempt
   - Same age validation as new guest

#### New Error Dialog:

```dart
_showAgeVerificationError(String name, int age)
```

Displays professional error dialog with:

- Warning icon and red theme
- User's name and detected age
- Clear explanation of 18+ requirement
- Reference to Malaysia's legal driving age

## User Experience Flow

### Successful Authentication (18+):

```
1. Scan MyKAD → "Scan MyKAD to Register..."
2. Age extracted → "Age Verified (25 years) - Registering..."
3. Registration complete → "Registration Complete!"
4. Navigate to dashboard
```

### Failed Authentication (Under 18):

```
1. Scan MyKAD → "Scan MyKAD to Register..."
2. Age extracted → "Access Denied: Must be 18+ to drive"
3. Error dialog appears with detailed explanation
4. Returns to lock screen
```

## Testing

### Mock Data:

- **Owner (Valid)**: `950123-01-5678` = 29 years old ✓
- **Guest (Valid)**: `010515-10-1234` = 23 years old ✓
- **Underage (Test)**: `100101-01-1234` = 14 years old ✗

### To Test Underage Scenario:

Modify the mock KAD numbers in `lock_screen.dart`:

- Line ~337: Change `mockKadNumber` to `'100101-01-1234'` (born 2010)
- Expected: Age verification error dialog appears

## Technical Notes

### MyKAD Format:

Malaysian Identity Card (MyKAD) number format: `YYMMDD-PP-NNNN`

- `YY`: Year of birth (2 digits)
- `MM`: Month of birth
- `DD`: Day of birth
- `PP`: Place of birth code
- `NNNN`: Random digits

### Age Calculation:

Accounts for:

- Full years lived
- Whether birthday has occurred this year
- Leap years (handled by Dart's DateTime)

### Security Considerations:

- Age verification happens on every access attempt
- Cannot bypass by using cached credentials
- Guest access requires re-verification even if previously granted

## Files Modified

1. `lib/models/registered_kad.dart` - Added DOB field and age verification logic
2. `lib/providers/car_provider.dart` - Updated registration to include DOB extraction
3. `lib/screens/lock_screen.dart` - Added age verification to all auth flows

## Compliance

This implementation ensures compliance with:

- **Malaysia Road Transport Act 1987** - Minimum driving age of 18 years
- **MyKAD verification** - Uses official IC format for age extraction
- **JPJ (Jabatan Pengangkutan Jalan) requirements** - Digital age verification

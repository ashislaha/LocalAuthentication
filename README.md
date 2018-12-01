# Local Authentication using biometric:

Using Face ID and Touch ID, the iOS app can authorize your identity and send the log in information to the back-end without 
any user interaction with the app. This is one of the most secure way to identify the user. Let's see how to implement it.

In the world of computer security, authentication falls into 3 categories:

(1). Something you know like user_id and password, PIN number etc. which are considered <b>less secure</b>. 

(2). Something you have like it generates OTP (one time password), phone call to your personal mobile device etc.

(3). Something you are, this is <b>most secure</b>, which refers to a physical attribute of your body which is unique to the user. Like biometric information of retina scan, voice recognition, facial recognition, finger-print etc. 

## Architecture of local authentication:

<img width="1085" alt="local_auth_architecture" src="https://user-images.githubusercontent.com/10649284/49329276-05771f00-f5a2-11e8-89cc-1f0ff841c2cc.png">

## The local authentication framework:

Biometric authentication for ios app is implemented using local authentication framework: <b>LAContext</b>

### Flow 1: User enters the user_name and password first time

### Flow 2: On success of log-in, the app will save the password to key-chain and user-name into user-defaults to use it later

### Flow 3: While next time onwards, the user comes to LogIn page, the app retrieves user-name from user-defaults and password from key-chain and check whether the app can evaluate the authentication using biometric.

### Flow 4: If the device supports Touch ID and Face ID, it will call logIn Service with stored user_name and password after successfully validating the user biometric.

## Face ID:
![face_id](https://user-images.githubusercontent.com/10649284/48486603-02f69480-e842-11e8-8f39-cb773c40501e.gif)

## Touch ID:
![touch_id](https://user-images.githubusercontent.com/10649284/48487385-17d42780-e844-11e8-8b20-14a0b3936f7d.gif)

### authenticate:
      
      func authenticateUser(successBlock: (() -> ())?, failureBlock: (()->())?) {
        
        // retrieve the user name
        guard let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String else { return }
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // device can be used for biometric authentication
            // evalutate the policy
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { (success, err) in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        switch context.biometryType {
                        case .faceID, .touchID:
                            print("device support faceId or touchId authentication")
                            self?.loadPasswordFromKeychainAndAuthenticateUser(lastAccessedUserName, successBlock: successBlock, failureBlock: failureBlock)
                        default: break
                        }
                    }
                }
            }
        } else { // device cannot be used for biometric authentication
            if let error = error {
                switch error.code {
                case LAError.Code.biometryNotEnrolled.rawValue: print("biometry is not enrolled")
                case LAError.Code.biometryLockout.rawValue: print("the phone is not passcode protected")
                case LAError.Code.biometryNotAvailable.rawValue: print("biometry is not availabled")
                default: break
                }
            }
        }
    }


## How to simulate Face ID in simulator:

Target should be iPhone X and upper version which supports Face ID.

### 1. add privacy key into info.plist for face id:

<img width="512" alt="screen shot 2018-11-14 at 9 41 39 am" src="https://user-images.githubusercontent.com/10649284/48486809-89ab7180-e842-11e8-9837-81e8d9d47393.png">

### 2. Select simulator, hardware and choose face id and select enroll: 

<img width="186" alt="screen shot 2018-11-14 at 6 52 31 pm" src="https://user-images.githubusercontent.com/10649284/48486889-b3fd2f00-e842-11e8-9546-5aa919ba8a8b.png">

### 3. While Face id view comes in simulator front, use "matching face":

<img width="180" alt="screen shot 2018-11-14 at 6 53 57 pm" src="https://user-images.githubusercontent.com/10649284/48486896-b6f81f80-e842-11e8-8d40-4acb99648f1d.png">


## How to simulate Touch ID in simulator:

Target should support Touch ID like iPhone 8, 8 plus etc.

### 1. selector simulator, hardware and choose Touch ID and select enroll:

<img width="207" alt="screen shot 2018-11-14 at 6 58 04 pm" src="https://user-images.githubusercontent.com/10649284/48487099-3c7bcf80-e843-11e8-806a-19d5de52b341.png">

### 2. select matching touch while Touch ID view will appear.

![simulator screen shot - iphone 8 - 2018-11-14 at 19 00 04](https://user-images.githubusercontent.com/10649284/48487119-46053780-e843-11e8-9cbb-bef7ca0e7df6.png)



## Helping documents:

https://www.techotopia.com/index.php/Implementing_TouchID_Authentication_in_iOS_8_Apps

https://developer.apple.com/documentation/security/keychain_services







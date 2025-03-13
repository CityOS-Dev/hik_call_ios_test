import UIKit
import Flutter
import PushKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Setup VOIP
    let mainQueue = DispatchQueue.main
    let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
    voipRegistry.delegate = self
    voipRegistry.desiredPushTypes = [PKPushType.voIP]
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: "Intercom", handle: "generic", type: 1)
          data.duration = 30000
          data.appName = "Test IO Call"
          data.audioSessionMode = "default"
          data.audioSessionActive = true
          data.audioSessionPreferredSampleRate = 44100
          data.audioSessionPreferredIOBufferDuration = 0.005
          data.supportsDTMF = true
          data.supportsVideo = true
          data.supportsHolding = false
          data.supportsGrouping = false
          data.supportsUngrouping = false
          data.ringtonePath = "system_ringtone_default"
          data.extra = [:]

          SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
      }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data) {
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)

       
    }

    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }

    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("didReceiveIncomingPushWith")
        guard type == .voIP else { return }

//         let data = flutter_callkit_incoming.Data(id: UUID().uuidString, nameCaller: "Домофон", handle: "generic", type: 1)
//         data.duration = 30000
//         data.appName = "NW Home"
//         data.audioSessionMode = "default"
//         data.audioSessionActive = true
//         data.audioSessionPreferredSampleRate = 44100
//         data.audioSessionPreferredIOBufferDuration = 0.005
//         data.supportsDTMF = true
//         data.supportsVideo = true
//         data.supportsHolding = false
//         data.supportsGrouping = false
//         data.supportsUngrouping = false
//         data.ringtonePath = "system_ringtone_default"
//         data.extra = payload.dictionaryPayload as NSDictionary
//
//         SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
//
//         // Make sure call completion()
//         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//             completion()
//         }
    }
}

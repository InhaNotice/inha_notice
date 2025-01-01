import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // 백그라운드 작업 등록 (iOS 13 이상에서만 실행)
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "my", using: nil) { task in
                self.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
        } else {
            // Fallback on earlier versions
        }


        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask) {
        // 백그라운드 작업 처리
        self.scheduleAppRefresh() // 다음 작업 예약

        task.expirationHandler = {
            // 작업이 완료되지 않을 경우 처리
            print("error")
        }

        // 작업 수행
        task.setTaskCompleted(success: true)
    }

    func scheduleAppRefresh() {
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: "my")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 * 60

            do {
                print("백그라운드 작업 예약 성공")
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Could not schedule app refresh: \(error)")
            }
        } else {
            print("BGTaskScheduler는 iOS 13 이상에서만 지원됩니다.")
        }
    }
}

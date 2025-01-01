import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.practiceCrawling", using: nil) { task in
                self.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()

        task.expirationHandler = {
            print("백그라운드 작업이 제한 시간 내에 완료되지 않았습니다.")
        }

        // 실제 작업 수행
        performBackgroundTask {
            task.setTaskCompleted(success: true)
        }
    }

    func scheduleAppRefresh() {
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: "com.example.practiceCrawling")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15분 후 실행

            do {
                try BGTaskScheduler.shared.submit(request)
                print("백그라운드 작업 예약 성공")
            } catch {
                print("백그라운드 작업 예약 실패: \(error)")
            }
        }
    }

    func performBackgroundTask(completion: @escaping () -> Void) {
        // 여기에서 작업 수행
        print("백그라운드 작업 수행 중...")
        completion()
    }
}
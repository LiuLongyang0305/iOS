# URL Loading System

## Overview

The URL Loading System provides access to resources indentified by URLs, using standard protocols like https or custom protocols you create. Loading is performed asynchronously, so your app can remain responsive and handle incoming data or errors as they arrive.

You use a URLSession instance to create one or more URLSessionTask instances, which can fetch and return data to your app, download files, or upload data and files to remote locations. To configure a session, you use a URLSessionConfigure object, which controls behaviors like how to use caches and cookies, or whether to allow connections on a cellular network.

You can use a session to create tasks repeatedly. Each session is associated with a delegate to receive a periodic updates (or errors). The default delegate calls a completion handler block that you have provide; if you choose to provide your own custom delegate, this block is not called.

You can configure a session to run in background, so that while the app is suspended, the system can download data on its behalf and wake up the app to deliever the results.

## First Steps

Configure and create sessions, then use the to create tasks that interact with URLs.

### Fetch Website Data into Memory

#### Overview2

For small interactions with remote servers, you can use URLSessionDataTask class to receive response data into memeory (as opposed to using URLSessionDownloadTask class, which stores the data dorectly to the file system). A data task is ideal for uses like calling a webservice endpoint.

You use a URL session instance to create the task. If your needs are fairly simple, you can use the shared instance of the URLSession class. If you want to interact with transfer through delegate callbacks, you will need to create a session instead of using the shared instance. You use a URLSessionConfiguration instance when creating a session, also passing a class that implements URLSessionDelegate or one of its subprotols. Sessions can be reused to create multiple tasks, so far each unique configuration you need, create a session and store it as a property.

Once you have a session, you create a data task with one of the dataTask() methods. Tasks are created in a suspend state, and can be started by calling resume().

#### Receive Results with a Completion Handlar

The simplest way to fetch data is to create a data task that uses a completion hanlder. With this arguement, the task delievers the servers response, data, and possibly errors to a completionn handler block that you provide.

![FetchData](./FetchData.png)

To create a data task that uses a completion handler, call the dataTask(with:) method of URLSession. Your completion handler needs to do three things:

1. Verify that error parameter is nil. If not, a transport error has occured; handle the error and exit.
2. Check the response parameter to vertify that the status code indicates success and that the MIME type is an expected type. If not, handle the server error and exit.
3. Use the data intances as needed.

```swift
func startLoad() {
    let url = URL(string: "https://www.example.com/")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            self.handleClientError(error)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            self.handleServerError(response)
            return
        }
        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
            let data = data,
            let string = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.webView.loadHTMLString(string, baseURL: url)
            }
        }
    }
    task.resume()
}
```

#### Receive Transfer Datails and Results with a delegate

For a greater level of access to the task's activuty as it proceeds, when creating the data task, you can set delegate on the session, rather providing a completion handler.

![FetchDataHandleDetails](./FetchDataHandleDetails.png)

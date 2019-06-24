// var test = null;

// var state = document.getElementById('content-capture');

// var myVal = ""; // Drop down selected value of reader 
// var disabled = true;
// var startEnroll = false;

// var currentFormat = Fingerprint.SampleFormat.PngImage;
// var deviceTechn = {
//                0: "Unknown",
//                1: "Optical",
//                2: "Capacitive",
//                3: "Thermal",
//                4: "Pressure"
//             }

// var deviceModality = {
//                0: "Unknown",
//                1: "Swipe",
//                2: "Area",
//                3: "AreaMultifinger"
//             }

// var deviceUidType = {
//                0: "Persistent",
//                1: "Volatile"
//             }

// var FingerprintSdkTest = (function () {
// 	function FingerprintSdkTest() {
// 		var _instance = this;
//       this.operationToRestart = null;
//       this.acquisitionStarted = false;
//       this.sdk = new Fingerprint.WebApi;
//       this.sdk.onDeviceConnected = function (e) {
//         // Detects if the deveice is connected for which acquisition started
//         alert("Scan your finger");
//       };
//       this.sdk.onDeviceDisconnected = function (e) {
//         // Detects if device gets disconnected - provides deviceUid of disconnected device
//         alert("Device disconnected");
//       };
//       this.sdk.onCommunicationFailed = function (e) {
//         // Detects if there is a failure in communicating with U.R.U web SDK
//         alert("Communinication Failed")
//       };
//       this.sdk.onSamplesAcquired = function (s) {
//         // Sample acquired event triggers this function
//         sampleAcquired(s);
//       };
//       this.sdk.onQualityReported = function (e) {
//         // Quality of sample aquired - Function triggered on every sample acquired
//         document.getElementById("qualityInputBox").value = Fingerprint.QualityCode[(e.quality)];
//       }

//     }
// 	}
// 	FingerprintSdkTest.prototype.getDeviceList = function () {
// 		return this.sdk.enumerateDevices();
// 	};
// 	FingerprintSdkTest.prototype.getDeviceInfoWithID = function (uid) {
// 		var _instance = this;
// 		return this.sdk.getDeviceInfo(uid);
// 	};
// 	FingerprintSdkTest.prototype.startCapture = function () {
// 		this.sdk.startAcquisition(Fingerprint.SampleFormat.PngImage).then(function () {
// 			console.log("You can start capturing !!!");
// 		}, function (error) {
// 			console.log(error.message);
// 		});
// 	};
// 	FingerprintSdkTest.prototype.stopCapture = function () {
// 		this.sdk.stopAcquisition().then(function () {
// 			console.log("Capturing stopped !!!");
// 		}, function (error) {
// 			showMessage(error.message);
// 		});
// 	};
// 	return FingerprintSdkTest;
// })();

// window.onload = function () {
// 	localStorage.clear();
// 	test = new FingerprintSdkTest();
// 	var allReaders = test.getDeviceList();
// 		allReaders.then(function (sucessObj) {
// 			for (i=0;i<sucessObj.length;i++){
// 			printDeviceInfo(sucessObj[i]);
// 		}
// 	}, function (error){
// 		console.log(error.message);
// 	});
// }

// // window.onload = function () {
// //     localStorage.clear();
// //     test = new FingerprintSdkTest();
// //     readersDropDownPopulate(true); //To populate readers for drop down selection
// //     disableEnable(); // Disabling enabling buttons - if reader not selected
// //     enableDisableScanQualityDiv("content-reader"); // To enable disable scan quality div
// //     disableEnableExport(true);
// // };

// function onStart() {
// 	test = new FingerprintSdkTest();
// 	test.startCapture();
// }

// function onStop() {
// 	test = new FingerprintSdkTest();
// 	test.stopCapture();
// }

// function printDeviceInfo(uid){
// 	var myDeviceVal = test.getDeviceInfoWithID(uid);
// 	myDeviceVal.then(function (sucessObj) {
// 		//A string containing the unique identifier of the fingerprint reader.
// 		console.log(sucessObj.DeviceID); 
// 		// One of the DeviceUidType enumeration values that specifies the type of 
// 		// the unique identifier of the fingerprint reader.
// 		console.log(Fingerprint.DeviceTechnology[sucessObj.eDeviceTech]); 
// 		// One of the DeviceModality enumeration values that specifies the capture 
// 		// process used by the fingerprint reader.
// 		console.log(Fingerprint.DeviceModality[sucessObj.eDeviceModality]); 
// 		// One of the DeviceTechnology enumeration values that specifies the fingerprint reader technology.
// 		console.log(Fingerprint.DeviceUidType[sucessObj.eUidType]); s
// 	}, function (error){
// 		console.log(error.message);
// 	});
// }
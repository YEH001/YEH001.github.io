---
title: Unity:PokemonGo
date: 2023-06-03 10:00:39
tags:
- Unity
categories:
- Unity
---

关于Unity和高德地图配置

<!-- more -->

### 获取高德SDK

详见 https://lbs.amap.com/api/android-location-sdk/locationsummary/

#### 导包

libs导入jar包，jniLibs导入so库

#### 显示地图

##### 权限申请

AndroidManifest.xml

```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.njust.locationtest">
    <!--允许程序打开网络套接字-->
    <uses-permission android:name="android.permission.INTERNET" />
    <!--允许程序设置内置sd卡的写权限-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <!--允许程序获取网络状态-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!--允许程序访问WiFi网络信息-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <!--允许程序读写手机状态和身份-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <!--允许程序访问CellID或WiFi热点来获取粗略的位置-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <!--允许获取精确位置，精准定位必选-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <!--允许获取设备和运营商信息，用于问题排查和网络定位（无gps情况下的定位），若需网络定位功能则必选-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <!--允许获取网络状态，用于网络定位（无gps情况下的定位），若需网络定位功能则必选-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!--允许获取wifi网络信息，用于网络定位（无gps情况下的定位），若需网络定位功能则必选-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <!--允许获取wifi状态改变，用于网络定位（无gps情况下的定位），若需网络定位功能则必选-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <!--如果设置了target >= 28 如果需要启动后台定位则必须声明这个权限-->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <!--后台获取位置信息，若需后台定位则必选-->
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <!--用于申请调用A-GPS模块,卫星定位加速-->
    <uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS" />
    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.LocationTest">
        <meta-data android:name="com.amap.api.v2.apikey" android:value="dc9e54fb7b82ae1ef377242ea7e85517"></meta-data>
        <service android:name="com.amap.api.location.APSService"></service>
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity
            android:name=".LocationActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```

##### 实现定位

LocationActivity :

```
package com.njust.locationtest;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.icu.text.SimpleDateFormat;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import java.util.Date;

public class LocationActivity extends Activity implements AMapLocationListener {
    private static final int MY_PERMISSIONS_REQUEST_CALL_LOCATION = 1;
    public AMapLocationClient mlocationClient;
    public AMapLocationClientOption mLocationOption = null;
    public TextView location;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location);
        location = (TextView) findViewById(R.id.TV_LOCATION2);
        //使用定位前设置隐私合规
        AMapLocationClient.updatePrivacyShow(this,true,true);
        AMapLocationClient.updatePrivacyAgree(this,true);
        //检查版本是否大于M
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        MY_PERMISSIONS_REQUEST_CALL_LOCATION);
            } else {
                //"权限已申请";
                showLocation();
            }
        }

    }
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == MY_PERMISSIONS_REQUEST_CALL_LOCATION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                //"权限已申请"
                showLocation();
            } else {
                Toast.makeText(getBaseContext(),"权限已拒绝,不能定位",Toast.LENGTH_SHORT).show();

            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    // TODO:
    private void showLocation() {
        try {
            mlocationClient = new AMapLocationClient(this);
            mLocationOption = new AMapLocationClientOption();
            mlocationClient.setLocationListener(this);
            //设置定位模式为高精度模式，Battery_Saving为低功耗模式，Device_Sensors是仅设备模式
            mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
            mLocationOption.setInterval(1000);
            //设置定位参数
            mlocationClient.setLocationOption(mLocationOption);
            //启动定位
            mlocationClient.startLocation();
        } catch (Exception e) {

        }
    }
    @TargetApi(24)
    @Override
    public void onLocationChanged(AMapLocation amapLocation) {
        try {
            if (amapLocation != null) {
                StringBuffer dz = new StringBuffer();
                if (amapLocation.getErrorCode() == 0) {
                    //定位成功回调信息，设置相关消息
                    Toast.makeText(getBaseContext(),"收到定位",Toast.LENGTH_SHORT).show();
                    //获取当前定位结果来源，如网络定位结果，详见定位类型表
                    dz.append("定位类型:  "+ amapLocation.getLocationType() + "\n");
                    dz.append("获取纬度:  "+ amapLocation.getLatitude() + "\n");
                    dz.append("获取经度:  "+ amapLocation.getLongitude() + "\n");
                    dz.append("获取精度信息:  "+ amapLocation.getAccuracy() + "\n");

                    //如果option中设置isNeedAddress为false，则没有此结果，网络定位结果中会有地址信息，GPS定位不返回地址信息。
                    dz.append("地址:  "+ amapLocation.getAddress() + "\n");
                    dz.append("国家信息:  "+ amapLocation.getCountry() + "\n");
                    dz.append("省信息:  "+ amapLocation.getProvince() + "\n");
                    dz.append("城市信息:  "+ amapLocation.getCity() + "\n");
                    dz.append("城区信息:  "+ amapLocation.getDistrict() + "\n");
                    dz.append("街道信息:  "+ amapLocation.getStreet() + "\n");
                    dz.append("获取当前定位点的AOI信息:  "+ amapLocation.getAoiName() + "\n");
                    dz.append("获取GPS的当前状态:  "+ amapLocation.getGpsAccuracyStatus() + "\n");
                    //获取定位时间
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date date = new Date(amapLocation.getTime());
                    dz.append("获取定位时间:  "+  df.format(date)+ "\n");
                    location.setText(dz);
                    // 停止定位
                    //mlocationClient.stopLocation();
                } else {
                    //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
                    Log.e("AmapError", "location Error, ErrCode:"
                            + amapLocation.getErrorCode() + ", errInfo:"
                            + amapLocation.getErrorInfo());
                }
            }
            else{
                Toast.makeText(getBaseContext(),"定位失败",Toast.LENGTH_SHORT).show();

            }
        } catch (Exception e) {
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        // 停止定位
        if (null != mlocationClient) {
            mlocationClient.stopLocation();
        }
    }

    /**
     * 销毁定位
     */
    private void destroyLocation() {
        if (null != mlocationClient) {
            /**
             * 如果AMapLocationClient是在当前Activity实例化的，
             * 在Activity的onDestroy中一定要执行AMapLocationClient的onDestroy
             */
            mlocationClient.onDestroy();
            mlocationClient = null;
        }
    }

    @Override
    protected void onDestroy() {
        destroyLocation();
        super.onDestroy();
    }

}
```

##### 显示地图

MainActivity :

```
package com.njust.locationtest;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.icu.text.SimpleDateFormat;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps.AMap;
import com.amap.api.maps.MapView;
import com.amap.api.maps.MapsInitializer;
import com.amap.api.maps.model.MyLocationStyle;

import java.util.Date;

public class MainActivity extends Activity implements AMapLocationListener {
    //显示地图
    private MapView mapView;
    private AMap aMap;
    public TextView loca;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        loca = (TextView) findViewById(R.id.TV_LOCATION);
        //使用地图前设置隐私合规
        MapsInitializer.updatePrivacyShow(this,true,true);
        MapsInitializer.updatePrivacyAgree(this,true);
        //获取地图控件引用
        mapView = (MapView) findViewById(R.id.map);
        //在activity执行onCreate时执行mMapView.onCreate(savedInstanceState)，创建地图
        mapView.onCreate(savedInstanceState);
        //显示地图
        if(aMap==null){
            aMap = mapView.getMap();
        }
        //显示蓝点
        MyLocationStyle myLocationStyle;
        //初始化定位蓝点样式类myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE);
        //连续定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动。（1秒1次定位）如果不设置myLocationType，默认也会执行此种模式。
        myLocationStyle = new MyLocationStyle();
        //设置连续定位模式下的定位间隔，只在连续定位模式下生效，单次定位模式下不会生效。单位为毫秒。
        myLocationStyle.interval(2000);
        //设置定位蓝点的Style
        aMap.setMyLocationStyle(myLocationStyle);
        // 设置为true表示启动显示定位蓝点，false表示隐藏定位蓝点并不进行定位，默认是false。
        aMap.setMyLocationEnabled(true);
        myLocationStyle.showMyLocation(true);

    }
    @TargetApi(24)
    @Override
    public void onLocationChanged(AMapLocation location) {
        //从location对象中获取经纬度信息，地址描述信息，建议拿到位置之后调用逆地理编码接口获取（获取地址描述数据章节有介绍）
        try {
            if (location != null) {
                StringBuffer dz = new StringBuffer();
                //定位成功回调信息，设置相关消息
                Toast.makeText(getBaseContext(),"收到定位",Toast.LENGTH_SHORT).show();
                //获取当前定位结果来源，如网络定位结果，详见定位类型表
                dz.append("获取纬度:  "+ location.getLatitude() + "\n");
                dz.append("获取经度:  "+ location.getLongitude() + "\n");
                dz.append("获取精度信息:  "+ location.getAccuracy() + "\n");
                loca.setText(dz);
                } else {
                    //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
                    Log.e("AmapError", "location Error, ErrCode:"
                            + location.getErrorCode() + ", errInfo:"
                            + location.getErrorInfo());
                }
        } catch (Exception e) {
        }
    }
    public void startLocation(View view) {
        startActivity(new Intent(this, LocationActivity.class));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //在activity执行onDestroy时执行mMapView.onDestroy()，销毁地图
        mapView.onDestroy();
    }
    @Override
    protected void onResume() {
        super.onResume();
        //在activity执行onResume时执行mMapView.onResume ()，重新绘制加载地图
        mapView.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
        //在activity执行onPause时执行mMapView.onPause ()，暂停地图的绘制
        mapView.onPause();
    }
    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        //在activity执行onSaveInstanceState时执行mMapView.onSaveInstanceState (outState)，保存地图当前的状态
        mapView.onSaveInstanceState(outState);
    }

}
```



以上，在AndroidStudio中可顺利获取地图和经纬度。

但是！！！由于地图对Unity支持度不高，所以打包转unity什么的很麻烦，所以暂时采用Unity 中 Gomap插件进行地图的导入。

由于GoMap使用的是MapBox定位，担心那一天国内不能用，所以先做这个插件预备，用于获取经纬度及经纬度数据。但是其中地图渲染和坐标转换之类的API完全比不上GoMap。

### 引入GoMap插件实现LBS

#### 导入插件

​		新建Unity 工程，导入GoMap插件及输入密钥。

#### 坑

​		做到根据经纬度生成宝可梦的时候会遇到一个很可怕的事情，unityEngine里面有一个类叫Coordinates，GoMap里面也有一个类叫Coordinates，重名会产生二义性，然后我找不到排除指定类的方法。我用了一个最蠢的办法，把GoMap中所有叫Coordinates的都改成了GoShared.Coordinates

#### 设置特殊生成宝可梦的POI点

​		先在地图上获取想要生成宝可梦的POI点经纬度或区域（拓展：可加入天气数据）

坐标转换的代码如下：

```C#
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GoShared;

public class Coordinates : MonoBehaviour
{
    public GameObject InsCube;
    public Text Text_Coordinate;
    // Start is called before the first frame update
    void Start()
    {
        SetCube();
    }

    // Update is called once per frame
    void Update()
    {
        CheckPositon();
    }
    //人物坐标转换成经纬度
    public void CheckPositon()
    {
        GameObject _avatar = GameObject.FindGameObjectWithTag("Avatar");
        Vector3 _avatarV3 = _avatar.transform.position;
        GoShared.Coordinates _coordinates = GoShared.Coordinates.convertVectorToCoordinates(_avatarV3);
        Text_Coordinate.text = "Avatar Latitude:" + _coordinates.latitude + " Longtitude:" + _coordinates.longitude;
    }
    //经纬度转换成地图坐标
    public void SetCube()
    {
        GoShared.Coordinates _coordinates = new GoShared.Coordinates(32.0244827,118.8544158,0);
        Vector3 _v3 = _coordinates.convertCoordinateToVector(0);
        GameObject _cube = Instantiate(InsCube);
        _cube.transform.position = _v3;
    }
}
```

​		SetCude()可改为读取服务端数据生成宝可梦

### 引入Vuforia插件实现AR

#### 下载插件

​		可以在AssetStore中下载资源（免费的），然后到官网注册获取密钥

#### 新建AR Scene

##### 新建ARCamera

​		World Center Mode记得改成DEVICE以及Vuforia Configeration中的Device Tracker 的Track Device Pose 记得勾选，不同版本的Vuforia设置设备追踪的方法都不一样，我这个是10.15版本最新的。

##### 在ARCamera子物件绑定一个坐标用于生成精灵球

​		坐标为相对ARCamera的一个坐标

##### 在AR场景中选取随机位置生成宝可梦

​		宝可梦设定Y轴为0，以便显示在地上。ARCamera改成手持高度大概1.6米位置(注：ARCamera 中使用的坐标单位与现实相同)。

​		但是实机测试发现显示的位置和Unity自带模拟的不一样，ARCamera的Z轴依旧为0。

### 背包系统

​		背包系统保留初代设定，一个训练家只允许获取6只宝可梦。可通过丢弃或替换更换宝可梦。

#### 图鉴显示

​		目前还没找到正版图片资源，目前打算是未获取的宝可梦是黑色剪影+静态+???作为名字，已捕获宝可梦为3D缩略模型+待机状态+最大CP值+名字，已编成宝可梦为3D缩略模型+待机状态+CP值+名字点开可查询常出没地点和属性。

​		由于提取3D模型过于复杂，决定这个等提取完3d模型后再进行优化。

#### 背包显示

​		背包目前只实现显示前三个已获取宝可梦，有待实现丢弃功能。

#### 后续功能待添加

### 坐标相关

​		由于定位实在是太不灵敏了，在map上加了一个虚拟摇杆，也方便在宿舍进行测试。后续如果改成高德定位可能还会删掉吧，有点可惜。

### 存档功能

​		采用EasySave进行存档，实现了存档读档功能，后续想增加删档和读地图资源功能。在客户端实现一些简单服务端服务。

​		部分代码如下：

```
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class SaveAndLoad
{
    public static void Save()
    {
        ES3.Save<int>("BallNum", StaticData.BallNum);
        ES3.Save<int>("FoodNum", StaticData.FoodNum);
        ES3.Save<int>("PetNum", StaticData.PetList.Count);
        for (int i = 0; i < StaticData.PetList.Count; i++)
        {
            ES3.Save<string>("PetNum" + i.ToString(), StaticData.PetList[i].PetName);
            ES3.Save<int>("PetIndex" + i.ToString(), StaticData.PetList[i].PetIndex);
        }
    }
    public static void Load()
    {
        if (ES3.KeyExists("BallNum")&&ES3.KeyExists("PetNum"))
        {
            StaticData.BallNum = ES3.Load<int>("BallNum");
            StaticData.FoodNum = ES3.Load<int>("FoodNum");
            int _petNum = ES3.Load<int>("PetNum");
            for (int i = 0; i < _petNum; i++)
            {
                string _petName = ES3.Load<string>("PetNum" + i.ToString());
                int _petIndex = ES3.Load<int>("PetIndex" + i.ToString());
                StaticData.AddPet(new PetSave(_petName,_petIndex));
            }
        }
    }
}

```


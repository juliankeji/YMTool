//
//  YMImgPickerVC.swift
//  YDProcurement
//
//  Created by YDWY on 2017/5/5.
//  Copyright © 2017年 YDWY. All rights reserved.
//






//图片选择器

import UIKit

var  width = UIScreen.main.bounds.width
var  heigth = UIScreen.main.bounds.height

class YMImgPickerVC: UIViewController {
    
    
    var bgView : UIView?
    var cancelBtn : UIButton?
    var photoBtn : UIButton?
    var cameraBtn : UIButton?
    var callbackWithImg : ((_ imgData:Data) -> Void)? = nil
    
    
    var  imagePickerCtr : UIImagePickerController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initImagePickerCtr()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
}



//设置界面
extension YMImgPickerVC {
    
    fileprivate func setupUI(){
        //背景View
        bgView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 127, width: UIScreen.main.bounds.width, height: 127))
        bgView?.backgroundColor = UIColor.gray
        guard let bgview1 = bgView else {
            return ;
        }
        view.addSubview(bgview1)
        
        //取消按钮
        cancelBtn = UIButton(frame: CGRect(x: 0, y: 87, width: UIScreen.main.bounds.width, height: 40))
        cancelBtn?.setTitle("取消", for: .normal)
        cancelBtn?.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        cancelBtn?.setTitleColor(UIColor.black, for: .normal)
        cancelBtn?.tag = 10001
        cancelBtn?.backgroundColor = UIColor.white
        guard let btn = cancelBtn else {
            return ;
        }
        bgView?.addSubview(btn)
        
        
        //相册选择按钮
        photoBtn = UIButton(frame: CGRect(x: 0, y: 41, width: UIScreen.main.bounds.width, height: 40))
        photoBtn?.setTitle("从相册选择", for: .normal)
        photoBtn?.setTitleColor(UIColor.black, for: .normal)
        photoBtn?.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        photoBtn?.tag = 10002
        photoBtn?.backgroundColor = UIColor.white
        guard let btn1 = photoBtn else {
            return ;
        }
        bgView?.addSubview(btn1)
        
        
        //照相按钮
        cameraBtn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        cameraBtn?.setTitle("拍照", for: .normal)
        cameraBtn?.setTitleColor(UIColor.black, for: .normal)
        cameraBtn?.tag = 10003
        cameraBtn?.backgroundColor = UIColor.white
        cameraBtn?.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        guard let btn2 = cameraBtn else {
            return ;
        }
        bgView?.addSubview(btn2)
        
    }
    
    fileprivate func initImagePickerCtr(){
        
        imagePickerCtr = UIImagePickerController()
        imagePickerCtr.delegate = self
        //设置是否可以管理已经存在的图片或视频
        imagePickerCtr.allowsEditing = true
        
        
        
    }
    
    
}




//按钮带点击的方法
extension YMImgPickerVC {
    
    
    @objc fileprivate func btnClick(btn : UIButton){
        switch btn.tag {
            
        case 10001:
            YMlog(message:btn.currentTitle!+"\(btn.tag)")
            self.dismiss(animated: true, completion: {
                
            })
            
            
            
        case 10002:
            //相册
            YMlog(message:btn.currentTitle!+"\(btn.tag)")
            chooseImg(type: .photoLibrary)
            
            
        case 10003:
            //相机
            YMlog(message:btn.currentTitle!+"\(btn.tag)")
            chooseImg(type: .camera)
        default:
            break
        }
        
    }
    
    
    
    //相册选择或拍照
    func chooseImg(type:UIImagePickerControllerSourceType){
        
        imagePickerCtr.sourceType = type
        if UIImagePickerController.isSourceTypeAvailable(type){
            self.present(imagePickerCtr, animated: true, completion: {
                
            })
            
        }else{
            YMPrint(message: "没有权限")
        }
        
        
    }
    
}



//MARK: - UIImagePickerControllerDelegate
extension YMImgPickerVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let  img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        
        //压缩图片
        //默认压缩到100KB
        let  imgData = compressImage(image: img ?? UIImage(), maxLength: 1024*100) //  UIImageJPEGRepresentation(img!, 0.5)
        YMPrint(message: imgData)
        picker.dismiss(animated: true, completion: {
            
            guard let data = imgData else {
                return ;
            }
            self.callbackWithImg!(data)
            
        })
        self.dismiss(animated: true) {
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
        self.dismiss(animated: true) {
            
        }
    }
    
    
    
}



//指定压缩图片大小
extension YMImgPickerVC {
    
    
    
    /// 预缩图片到指定字节
    ///
    /// - Parameters:
    ///   - image: 需要压缩的图片
    ///   - maxLength: 压缩的大小
    /// - Returns: 返回压缩的图片
    fileprivate func compressImage(image : UIImage, maxLength: Int ) -> Data? {
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(image, compress)
        while (data?.count)! > maxLength && compress > 0.001 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(image, compress)
        }
        return data
    }
    
}

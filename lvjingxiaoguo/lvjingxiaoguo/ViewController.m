//
//  ViewController.m
//  lvjingxiaoguo
//
//  Created by Myfly on 17/8/7.
//  Copyright © 2017年 Myfly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImageView *selectImageView;

@property (nonatomic, strong) CIFilter * colorControlsFilter;

@property (nonatomic, strong) CIContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.image = [UIImage imageNamed:@"image2.jpg"];
}

- (IBAction)btn1Action:(id)sender {
//    //1. 初始化CIContext //创建基于CPU的图像上下文
//    //    NSNumber *number=[NSNumber numberWithBool:YES];
//    //    NSDictionary *option=[NSDictionary dictionaryWithObject:number forKey:kCIContextUseSoftwareRenderer];
//    //  CIContext *context=[CIContext contextWithOptions:option];
//    
//    _context = [CIContext contextWithOptions:nil];
//    //使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐先在完成方法中保存图像，然后在主程序中调用
//    //    EAGLContext *eaglContext=[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
//    //    CIContext *context=[CIContext contextWithEAGLContext:eaglContext];
//    //OpenGL优化过的图像上下文
//    //2. 取得滤镜
//    CIFilter * colorControlsFilter=[CIFilter filterWithName:@"CIColorControls"];
//    //3. 初始化CIImage源图像
//    CIImage *image = [CIImage imageWithCGImage:_imageView.image.CGImage];
//    //4. 设置滤镜的输入图片
//    [colorControlsFilter setValue:image forKey:@"inputImage"];
//    //5. 设置滤镜参数
//#pragma mark 调整饱和度 
//    //[_colorControlsFilter setValue:[NSNumber numberWithFloat:60] forKey:@"inputSaturation"];
//#pragma mark 调整亮度 
//    //[colorControlsFilter setValue:[NSNumber numberWithFloat:60] forKey:@"inputBrightness"];
//#pragma mark 调整对比度 
//    //[colorControlsFilter setValue:[NSNumber numberWithFloat:60] forKey:@"inputContrast"];
//    //6 . 显示图片
//    [self setImage];
    
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    //#pragma mark 调整饱和度
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:0.5] forKey:@"inputSaturation"];
    //#pragma mark 调整亮度
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:0.4] forKey:@"inputBrightness"];
    //#pragma mark 调整对比度
    [_colorControlsFilter setValue:[NSNumber numberWithFloat:0.8] forKey:@"inputContrast"];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn2Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    [_colorControlsFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    
    [_colorControlsFilter setValue:[CIColor colorWithRed:0.3 green:0.5 blue:1] forKey:@"inputColor1"];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn3Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CILinearToSRGBToneCurve"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn4Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIToneCurve"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
    
}
- (IBAction)btn5Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIColorCrossPolynomial"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn6Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn7Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}
- (IBAction)btn8Action:(id)sender {
    CGImageRef cgImg = _selectImageView.image.CGImage;
    CIImage *coreImage = [CIImage imageWithCGImage:cgImg];
    _colorControlsFilter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    [_colorControlsFilter setValue:coreImage forKey:kCIInputImageKey];
    
    CIImage *output = _colorControlsFilter.outputImage;
    
    self.context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [self.context createCGImage:output fromRect:[output extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    _imageView.image = uiimage;
}

-(void)setImage{
    CIImage *outputImage= [_colorControlsFilter outputImage];//取得输出图像
    CGImageRef temp=[_context createCGImage:outputImage fromRect:[outputImage extent]];
    _imageView.image=[UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    CGImageRelease(temp);//释放CGImage对象
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

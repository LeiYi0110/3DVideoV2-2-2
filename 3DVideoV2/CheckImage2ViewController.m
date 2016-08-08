//
//  CheckImage2ViewController.m
//  3DVideoV2
//
//  Created by Lei on 6/5/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import "CheckImage2ViewController.h"

#import "AGLKVertexAttribArrayBuffer.h"

#import "AGLKContext.h"

@interface CheckImage2ViewController ()

@end

@implementation CheckImage2ViewController

@synthesize baseEffect;
@synthesize vertexBuffer;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

int partCount = 1920*2;//1920*2;//44160*2;//1920*2;//1920*2;//1000000;
static SceneVertex vertices[1920*2*4];
//SceneVertex vertices[partCount*4];
float offset = 0.03f;//0.015f;

/////////////////////////////////////////////////////////////////
-(void)initVertex
{
    
    if ([[UIScreen mainScreen] scale] == 2.0f) {
        partCount = 1334*2;
    }
    else
    {
        partCount = 1920*2;
    }
    
    
    //vertices = (SceneVertex*)malloc(4*sizeof(SceneVertex));
    SceneVertex *p = vertices;
    
    float screenWidth = 1.0f;
    
    Float64 vertexInterval = 4.0f*screenWidth/partCount;
    //NSLog(@"%f",vertexInterval);
    GLfloat startVertexPos = -1*screenWidth;//-1.0f;
    
    GLfloat textureInterval = 1.0f/partCount;
    //NSLog(@"%f",textureInterval);
    GLfloat startTexturePos = 0.0f;
    
    
    
    for(int i=0; i < partCount/2; i++)
    {
        
        
        GLKVector3  positionCoords0 = {startVertexPos + i*vertexInterval, screenWidth, 0.0f};
        p->positionCoords = positionCoords0;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords0 = {startTexturePos + i*textureInterval, 0.0f};
        p->textureCoords = textureCoords0;
        p++;
        
        GLKVector3  positionCoords1 = {startVertexPos + i*vertexInterval,  -1.0f*screenWidth, 0.0f};
        p->positionCoords = positionCoords1;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords1 = {startTexturePos + i*textureInterval, 1.0f};
        p->textureCoords = textureCoords1;
        p++;
        
        GLKVector3  positionCoords3 = {startVertexPos + (i + 1)*vertexInterval, screenWidth, 0.0f};
        p->positionCoords = positionCoords3;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords3 = {startTexturePos + (i + 1)*textureInterval, 0.0f};
        p->textureCoords = textureCoords3;
        p++;
        
        GLKVector3  positionCoords4 = {startVertexPos + (i + 1)*vertexInterval,  -1.0f*screenWidth, 0.0f};
        p->positionCoords = positionCoords4;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords4 = {startTexturePos + (i + 1)*textureInterval, 1.0f};
        p->textureCoords = textureCoords4;
        p++;
        
        
    }
    startTexturePos = 0.5f;
    offset = 1*vertexInterval;
    for(int i=0; i < partCount/2; i++)
    {
        GLKVector3  positionCoords0 = {startVertexPos + i*vertexInterval + offset, screenWidth, 0.0f};
        p->positionCoords = positionCoords0;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords0 = {startTexturePos + i*textureInterval, 0.0f};
        p->textureCoords = textureCoords0;
        p++;
        
        GLKVector3  positionCoords1 = {startVertexPos + i*vertexInterval + offset,  -1.0f*screenWidth, 0.0f};
        p->positionCoords = positionCoords1;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords1 = {startTexturePos + i*textureInterval, 1.0f};
        p->textureCoords = textureCoords1;
        p++;
        
        GLKVector3  positionCoords3 = {startVertexPos + (i + 1)*vertexInterval + offset, screenWidth, 0.0f};
        p->positionCoords = positionCoords3;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords3 = {startTexturePos + (i + 1)*textureInterval, 0.0f};
        p->textureCoords = textureCoords3;
        p++;
        
        GLKVector3  positionCoords4 = {startVertexPos + (i + 1)*vertexInterval + offset,  -1.0f*screenWidth, 0.0f};
        p->positionCoords = positionCoords4;//GLKVector3(-0.5f,-0.5f,0.0f);
        GLKVector2  textureCoords4 = {startTexturePos + (i + 1)*textureInterval, 1.0f};
        p->textureCoords = textureCoords4;
        p++;
        
        
    }
    
    
    
    
    NSLog(@"self.view width is %f, height is %f",self.view.frame.size.width,self.view.frame.size.height);
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVertex];
    //NSLog(@"%d",sizeof(vertices))
    NSLog(@"view scale is %f", self.view.contentScaleFactor);
    NSLog(@"scale is %f", [[UIScreen mainScreen] scale]);
    //self.view.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    float scale = [[UIScreen mainScreen] scale];
    if (scale == 3.0f) {
        self.view.contentScaleFactor = 3.0f/1.15;
    }
    else
    {
        self.view.contentScaleFactor = 2.0f;//2.0f/0.69479;
    }
    
    
    
    SceneVertex *p = vertices;
    //vertices = (SceneVertex *) malloc(16 * sizeof(SceneVertex));
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    /*
     self.baseEffect.constantColor = GLKVector4Make(
     1.0f, // Red
     1.0f, // Green
     1.0f, // Blue
     1.0f);// Alpha
     */
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    // Setup texture
    CGImageRef imageRef =
    [[UIImage imageNamed:@"RB.png"] CGImage];
    //[[UIImage imageNamed:@"image_1920.png"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader
                                   textureWithCGImage:imageRef
                                   options:nil
                                   error:NULL];
    
    //glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    
    UIImage *backImage = [UIImage imageNamed:@"check_back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIButton alloc] initWithFrame:CGRectMake(17, 24, 28, 14)];
    button.frame = CGRectMake(17, 24, backImage.size.width, backImage.size.height);
    [button setImage:backImage forState:UIControlStateNormal];
    
    //[button setTitle:@"返回" forState:UIControlStateNormal];
    //[button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}
-(void)backButtonPress:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    NSLog(@"width is %f, height is %f", self.view.frame.size.width,self.view.frame.size.height);
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    
    //offsetof(SceneVertex, textureCoords)
    NSLog(@"%lu",offsetof(SceneVertex, textureCoords));
    for(int i = 0; i < partCount; i = i + 2)
    {
        
        [self.vertexBuffer drawArrayWithMode:GL_TRIANGLE_STRIP//GL_TRIANGLES
                            startVertexIndex:4*i
                            numberOfVertices:4];
    }
    
    
    
    
    
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

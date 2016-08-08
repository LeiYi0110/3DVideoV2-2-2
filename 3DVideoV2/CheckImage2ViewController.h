//
//  CheckImage2ViewController.h
//  3DVideoV2
//
//  Created by Lei on 6/5/16.
//  Copyright © 2016 Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;

@interface CheckImage2ViewController : GLKViewController
{
    GLuint vertexBufferID;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@end

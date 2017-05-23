//
//  GameVC.m
//  gameTest
//
//  Created by cc on 17/3/3.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RedRoseGameVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtils.h"
#import "CCTapped.h"

static float LeftTimes = 0.2;
static float RightTimes = 0.5;

#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif
/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define Window  [[[UIApplication sharedApplication]delegate]window]

#define playNumPrefix    @"下注："
#define totalNumPrefix   @"结余："
#define choosePlayPrefix @"投注："
#define notChoosePlayStr    @"未选择"

@interface RedRoseGameVC (){
     NSInteger aaa1;
     NSInteger aaa2;
     NSInteger aaa3;
     NSInteger bbb1;
     NSInteger bbb2;
     NSInteger bbb3;
     NSInteger ccc1;
     NSInteger ccc2;
     NSInteger ccc3;
}

@property (weak, nonatomic) IBOutlet UIImageView *mycard1;
@property (weak, nonatomic) IBOutlet UIImageView *mycard2;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangcard1;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangcard2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
//@property (weak, nonatomic) IBOutlet UIButton *soundBtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankerBtn;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;
@property (weak, nonatomic) IBOutlet UIButton *tieBtn;
//@property (weak, nonatomic) IBOutlet UIButton *pairBtn;

@property (nonatomic)NSDictionary *pokersDic;
@property (nonatomic)NSArray *pokersArr;
@property (strong, nonatomic) UIImageView *moneySelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gold_5Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_10Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_20Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_50Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_100Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_500Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_1000Img;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *choosePlayLabel;//下注方
@property (weak, nonatomic) IBOutlet UILabel *TotalNumLab;//!<总共的金币
@property (weak, nonatomic) IBOutlet UILabel *playNumLab;//!<下注的金币
@property (nonatomic, assign) int playNum;//!<下注的金币
@property (nonatomic, assign) int totlaNum;//!<一共的金币
@property (nonatomic)NSMutableArray *leftArr;//!<左边的数组
@property (nonatomic)NSMutableArray *left100Arr;//!<左边100金币的数组
@property (nonatomic)NSMutableArray *left500Arr;//!<左边500金币的数组
@property (nonatomic)NSMutableArray *left1000Arr;//!<左边1000金币的数组

@property (nonatomic)NSMutableArray *rightArr;//!<右边的数组
@property (nonatomic)NSMutableArray *right100Arr;//!<右边100金币的数组
@property (nonatomic)NSMutableArray *right500Arr;//!<右边500金币的数组
@property (nonatomic)NSMutableArray *right1000Arr;//!<右边1000金币的数组
@property (nonatomic, assign) NSInteger choosePorB;//!<选择庄家或者闲家  0无选择  1闲家 2庄家 3和 4对

@property (strong, nonatomic) AVAudioPlayer *player;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numBottomHeigh;
//@property (weak, nonatomic) IBOutlet UIImageView *closeEffectImg;
@property (weak, nonatomic) IBOutlet UIImageView *closeMusicImg;
@property (nonatomic, assign) BOOL isPlaymusic;

@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation RedRoseGameVC

-(BOOL) shouldAutorotate{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    //    return UIInterfaceOrientationMaskLandscapeLeft;
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
    //    return UIInterfaceOrientationPortrait;
}

- (void)creatMp3:(NSString *)str
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:str ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&playerError];
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    //循环次数
    [_player setNumberOfLoops:-1];
    
    //播放声音
    [_player setVolume:0.1];
    
    //预备播放
    [_player prepareToPlay];
    
    //播放
    [_player play];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (iPhone4 || iPhone5) {
        _cardWidthConstraint.constant = 55;
        _cardHeightConstraint.constant = 70;
    }else {
        _cardWidthConstraint.constant = 65;
        _cardHeightConstraint.constant = 93;
    }
    
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.textColor = [UIColor redColor];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.backgroundColor = [UIColor clearColor];
    _alertLabel.font = [UIFont boldSystemFontOfSize:34];
    
    _isPlaymusic = YES;
    [AudioUtils play:@"loading_end"];
    [self creatMp3:@"BGMP"];
//    _leftArr = [@[]mutableCopy];
//    _rightArr = [@[]mutableCopy];
//    _left100Arr = [@[]mutableCopy];
//    _left500Arr = [@[]mutableCopy];
//    _left1000Arr = [@[]mutableCopy];
//    _right100Arr = [@[]mutableCopy];
//    _right500Arr = [@[]mutableCopy];
//    _right1000Arr = [@[]mutableCopy];
    _playNum = 0;
    _totlaNum = 5000;
    _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,notChoosePlayStr];
    _playNumLab.text = [NSString stringWithFormat:@"%@%d",playNumPrefix,_playNum];
    _TotalNumLab.text = [NSString stringWithFormat:@"%@%d",totalNumPrefix,_totlaNum];
    
    _pokersDic = @{@"a1.jpg":@"1",@"a2.jpg":@"2",@"a3.jpg":@"3",@"a4.jpg":@"4",@"a5.jpg":@"5",@"a6.jpg":@"6",@"a7.jpg":@"7",@"a8.jpg":@"8",@"a9.jpg":@"9",@"a10.jpg":@"0",@"a11.jpg":@"0",@"a12.jpg":@"0",@"a13.jpg":@"0",
                   @"b1.jpg":@"1",@"b2.jpg":@"2",@"b3.jpg":@"3",@"b4.jpg":@"4",@"b5.jpg":@"5",@"b6.jpg":@"6",@"b7.jpg":@"7",@"b8.jpg":@"8",@"b9.jpg":@"9",@"b10.jpg":@"0",@"b11.jpg":@"0",@"b12.jpg":@"0",@"b13.jpg":@"0",
                   @"c1.jpg":@"1",@"c2.jpg":@"2",@"c3.jpg":@"3",@"c4.jpg":@"4",@"c5.jpg":@"5",@"c6.jpg":@"6",@"c7.jpg":@"7",@"c8.jpg":@"8",@"c9.jpg":@"9",@"c10.jpg":@"0",@"c11.jpg":@"0",@"c12.jpg":@"0",@"c13.jpg":@"0",
                   @"d1.jpg":@"1",@"d2.jpg":@"2",@"d3.jpg":@"3",@"d4.jpg":@"4",@"d5.jpg":@"5",@"d6.jpg":@"6",@"d7.jpg":@"7",@"d8.jpg":@"8",@"d9.jpg":@"9",@"d10.jpg":@"0",@"d11.jpg":@"0",@"d12.jpg":@"0",@"d13.jpg":@"0"};
    _pokersArr = [_pokersDic allKeys];
    _choosePorB = 0;
    
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"reset"] forState:UIControlStateHighlighted];
    [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
    [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music"] forState:UIControlStateHighlighted];
    
    _moneySelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money_sel"]];
    _moneySelImgView.frame = CGRectMake(0, 0, 40, 40);
    
    [_gold_5Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_5Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }
            if (_totlaNum - 5 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:5];
            }
        }
    }];
    
    [_gold_10Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_10Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }
            if (_totlaNum - 10 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:10];
            }
        }
    }];
    
    [_gold_20Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_20Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }
            if (_totlaNum - 20 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:20];
            }
        }
    }];
    
    [_gold_50Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_50Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }
            if (_totlaNum - 50 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:50];
            }
        }
    }];
    
    [_gold_100Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_100Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }
            if (_totlaNum - 100 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:100];
            }
        }
    }];
    
    [_gold_500Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_500Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }else{
                
            }
            if (_totlaNum - 500 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:500];
            }
        }
    }];
    
    [_gold_1000Img whenTapped:^{
        {
            [_moneySelImgView removeFromSuperview];
            [_gold_1000Img addSubview:_moneySelImgView];
            if (_isPlaymusic == YES) {
                [AudioUtils play:@"ce_chip"];
            }else{
                
            }
            if (_totlaNum - 1000 < 0) {
                NSLog(@"123");
            }else{
                [self setNumLabelText:1000];
            }
        }
    }];
}

- (void)setNumLabelText:(int)num
{
    _playNum = _playNum+num;
    _totlaNum = _totlaNum-num;
    _playNumLab.text = [NSString stringWithFormat:@"%@%d",playNumPrefix,_playNum];
    _TotalNumLab.text = [NSString stringWithFormat:@"%@%d",totalNumPrefix,_totlaNum];

    [self setChoosePlayLabelText];
}

- (void)setChoosePlayLabelText
{
    if (_choosePorB == 1) {
        _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,@"闲"];
    }else if(_choosePorB == 2){
        _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,@"庄"];
    }else if(_choosePorB == 3){
        _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,@"和"];
    }else if(_choosePorB == 4){
        _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,@"对"];
    }
}

- (void)initNumLabelText
{
    _playNum = 0;
    _totlaNum = 5000;
    _playNumLab.text = [NSString stringWithFormat:@"%@%d",playNumPrefix,_playNum];
    _TotalNumLab.text = [NSString stringWithFormat:@"%@%d",totalNumPrefix,_totlaNum];
    _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,notChoosePlayStr];
}

#pragma mark -- 重置按钮
- (IBAction)resetBtn:(id)sender
{
    [_moneySelImgView removeFromSuperview];
    [self initNumLabelText];
    _choosePorB = 0;
    aaa1 = 0;
    aaa2 = 0;
    aaa3 = 0;
    bbb1 = 0;
    bbb2 = 0;
    bbb3 = 0;
    ccc1 = 0;
    ccc2 = 0;
    ccc3 = 0;
    _mycard1.image = [UIImage imageNamed:@""];
    _mycard2.image = [UIImage imageNamed:@""];
    _zhuangcard1.image = [UIImage imageNamed:@""];
    _zhuangcard2.image = [UIImage imageNamed:@""];
//    [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music_nor"] forState:UIControlStateNormal];
//    [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music_nor"] forState:UIControlStateHighlighted];
    _playerBtn.userInteractionEnabled = YES;
    _bankerBtn.userInteractionEnabled = YES;
    _tieBtn.userInteractionEnabled = YES;
    //_pairBtn.userInteractionEnabled = YES;
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateNormal];
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateHighlighted];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateNormal];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateHighlighted];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateNormal];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateHighlighted];
    
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
//    for (UIImageView *img in _leftArr) {
//        [img removeFromSuperview];
//    }
//    [_leftArr removeAllObjects];
//    
//    for (UIImageView *img in _rightArr) {
//        [img removeFromSuperview];
//    }
//    [_rightArr removeAllObjects];
//    
//    for (UIImageView *img in _left100Arr) {
//        [img removeFromSuperview];
//    }
//    [_left100Arr removeAllObjects];
//    
//    for (UIImageView *img in _right100Arr) {
//        [img removeFromSuperview];
//    }
//    [_right100Arr removeAllObjects];
//    
//    for (UIImageView *img in _left500Arr) {
//        [img removeFromSuperview];
//    }
//    [_left500Arr removeAllObjects];
//    
//    for (UIImageView *img in _right500Arr) {
//        [img removeFromSuperview];
//    }
//    [_right500Arr removeAllObjects];
//    for (UIImageView *img in _left1000Arr) {
//        [img removeFromSuperview];
//    }
//    [_left1000Arr removeAllObjects];
//    
//    for (UIImageView *img in _right1000Arr) {
//        [img removeFromSuperview];
//    }
//    [_right1000Arr removeAllObjects];
//    //_playImg.userInteractionEnabled = YES;
}

#pragma mark -- play点击事件

- (void) timeEnough
{
    UIButton *btn=(UIButton*)[self.view viewWithTag:33];
    btn.selected=NO;
}

- (IBAction)playBtnClick:(UIButton *)sender
{
    if(sender.selected) return;
    sender.selected=YES;
    [self performSelector:@selector(timeEnough) withObject:nil afterDelay:5.0]; //3秒后又可以处理点击事件了

    [_moneySelImgView removeFromSuperview];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _alertLabel.frame = CGRectMake((size.width-size.width)/2, (size.height-50)/2, size.width, 50);
    if (_playNum == 0) {
        if (_isPlaymusic == YES) {
            [AudioUtils play:@"c_place_cn"];
        }else{
            
        }
        _alertLabel.text = @"请选筹码";
        [Window addSubview:_alertLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertLabel removeFromSuperview];
            sender.selected=NO;
        });
    }else{
        if (_choosePorB == 0) {
            _alertLabel.text = @"请选择任意一方下注";
            [Window addSubview:_alertLabel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_alertLabel removeFromSuperview];
                sender.selected=NO;
            });
            return;
        }
        
        if (_isPlaymusic == YES) {
            [AudioUtils play:@"squeeze_open"];
        }else{
            
        }
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIImageView *ansImg = [[UIImageView alloc] initWithFrame:CGRectMake((size.width-400)/2, 0, 400, size.height)];
        [self.view addSubview:ansImg];
        
        NSArray *arr = [self randomArray];
        _mycard1.image = [UIImage imageNamed:arr[0]];
        _mycard2.image = [UIImage imageNamed:arr[1]];
        _zhuangcard1.image = [UIImage imageNamed:arr[2]];
        _zhuangcard2.image = [UIImage imageNamed:arr[3]];
        NSInteger playerNum = [_pokersDic[arr[0]] integerValue] + [_pokersDic[arr[1]] integerValue];
        NSInteger bankerNum = [_pokersDic[arr[2]] integerValue] + [_pokersDic[arr[3]] integerValue];
        NSLog(@"%ld --- %ld",(long)playerNum,(long)bankerNum);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_choosePorB == 1) {
                if (playerNum >9 && bankerNum < 9) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [ansImg removeFromSuperview];
                            });
                        });
                    });
                }else if (playerNum < 9 && bankerNum >9){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"c_playerwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"pwin_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ansImg removeFromSuperview];
                            [self recycleCoin];
                        });
                        _totlaNum = _playNum +_totlaNum;
                        [self setTotlaNumLabelTextWithRate:1];
                    });
                }else if (playerNum > 9 && bankerNum >9){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_tiwin_cn"];
                    }else{
                        
                    }
                    ansImg.image = [UIImage imageNamed:@"tie"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ansImg removeFromSuperview];
                        [self recycleCoin];
                    });
                    [self setTotlaNumLabelTextWithRate:1];
                }else if (playerNum == bankerNum) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_tiwin_cn"];
                    }else{
                        
                    }
                    ansImg.image = [UIImage imageNamed:@"tie"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ansImg removeFromSuperview];
                        [self recycleCoin];
                    });
                    [self setTotlaNumLabelTextWithRate:1];
                }else if (playerNum > bankerNum){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"c_playerwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"pwin_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ansImg removeFromSuperview];
                            [self recycleCoin];
                        });
                        [self setTotlaNumLabelTextWithRate:1];
                    });
                }else{
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            [ansImg removeFromSuperview];
                        });
                    });
                }
            }else if (_choosePorB == 2){
                if (playerNum >9 && bankerNum < 9) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            [ansImg removeFromSuperview];
                        });
                    });
                }else if (playerNum < 9 && bankerNum >9){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"c_playerwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"pwin_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ansImg removeFromSuperview];
                            [self recycleCoin];
                        });
                        [self setTotlaNumLabelTextWithRate:2];
                    });
                }else if (playerNum > 9 && bankerNum >9){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_tiwin_cn"];
                    }else{
                        
                    }
                    ansImg.image = [UIImage imageNamed:@"tie"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ansImg removeFromSuperview];
                        [self recycleCoin];
                    });
                    [self setTotlaNumLabelTextWithRate:1];
                }else if (playerNum == bankerNum) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_tiwin_cn"];
                    }else{
                        
                    }
                    ansImg.image = [UIImage imageNamed:@"tie"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ansImg removeFromSuperview];
                        [self recycleCoin];
                    });
                    [self setTotlaNumLabelTextWithRate:1];
                }else if (playerNum > bankerNum){
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"c_playerwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            [ansImg removeFromSuperview];
                        });
                    });
                }else{
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"pwin_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ansImg removeFromSuperview];
                            [self recycleCoin];
                        });
                        [self setTotlaNumLabelTextWithRate:2];
                    });
                }
            } else if (_choosePorB == 3) {
                if (playerNum == bankerNum) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self recycleCoin];
                            [ansImg removeFromSuperview];
                        });
                        [self setTotlaNumLabelTextWithRate:8];
                    });
                } else {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            [ansImg removeFromSuperview];
                        });
                    });
                }
            } else if ( _choosePorB == 4) {
                NSMutableArray *numArr = [[NSMutableArray alloc] initWithCapacity:4];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i];
                    NSArray *temp=[str componentsSeparatedByString:@"."];
                    NSString *res = [temp[0] substringFromIndex:1];
                    [numArr addObject:res];
                }
                if ([numArr[0] isEqualToString:numArr[1]] || [numArr[2] isEqualToString:numArr[3]]) {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"win"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self recycleCoin];
                            [ansImg removeFromSuperview];
                        });
                        [self setTotlaNumLabelTextWithRate:11];
                    });
                } else {
                    if (_isPlaymusic == YES) {
                        [AudioUtils play:@"ba_bwin_cn"];
                    }else{
                        
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_isPlaymusic == YES) {
                            [AudioUtils play:@"plose_money"];
                        }else{
                            
                        }
                        ansImg.image = [UIImage imageNamed:@"lose"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self removeCoin];
                            [ansImg removeFromSuperview];
                        });
                    });
                }
            }
        });
    }
}

- (void)setTotlaNumLabelTextWithRate:(int)rate
{
    _totlaNum = _playNum*rate+_totlaNum;
    _TotalNumLab.text = [NSString stringWithFormat:@"%@%d",totalNumPrefix,_totlaNum];
}

#pragma mark -- 输了金币消失
- (void)removeCoin
{
    [_moneySelImgView removeFromSuperview];
    _playNum = 0;
    _playNumLab.text = [NSString stringWithFormat:@"%@%d",playNumPrefix,_playNum];
    _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,notChoosePlayStr];
    _choosePorB = 0;
    aaa1 = 0;
    aaa2 = 0;
    aaa3 = 0;
    bbb1 = 0;
    bbb2 = 0;
    bbb3 = 0;
    ccc1 = 0;
    ccc2 = 0;
    ccc3 = 0;
    _mycard1.image = [UIImage imageNamed:@""];
    _mycard2.image = [UIImage imageNamed:@""];
    _zhuangcard1.image = [UIImage imageNamed:@""];
    _zhuangcard2.image = [UIImage imageNamed:@""];
    _playerBtn.userInteractionEnabled = YES;
    _bankerBtn.userInteractionEnabled = YES;
    _tieBtn.userInteractionEnabled = YES;
    //_pairBtn.userInteractionEnabled = YES;
    
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateNormal];
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateHighlighted];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateNormal];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateHighlighted];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateNormal];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateHighlighted];
    
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
//    for (UIImageView *img in _left100Arr) {
//        //            [UIView animateWithDuration:LeftTimes*2 animations:^{
//        //                img.frame = _gold_100Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });
//    }
//    [_left100Arr removeAllObjects];
//    for (UIImageView *img in _left500Arr) {
//        //            [UIView animateWithDuration:LeftTimes*2 animations:^{
//        //                img.frame = _gold_200Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });                }
//    [_left500Arr removeAllObjects];
//    for (UIImageView *img in _left1000Arr) {
//        //            [UIView animateWithDuration:LeftTimes*2 animations:^{
//        //                img.frame = _gold_300Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });                }
//    [_left1000Arr removeAllObjects];
//    for (UIImageView *img in _right100Arr) {
//        //            [UIView animateWithDuration:RightTimes animations:^{
//        //                img.frame = _gold_100Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });                }
//    [_right100Arr removeAllObjects];
//    for (UIImageView *img in _right500Arr) {
//        //            [UIView animateWithDuration:RightTimes animations:^{
//        //                img.frame = _gold_200Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });                }
//    [_right500Arr removeAllObjects];
//    for (UIImageView *img in _right1000Arr) {
//        //            [UIView animateWithDuration:RightTimes animations:^{
//        //                img.frame = _gold_300Img.frame;
//        //            }];
//        //            [AudioUtils play:@"ce_chip"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [img removeFromSuperview];
//        });                }
//    [_right1000Arr removeAllObjects];
}

#pragma mark -- 赢了回收金币

- (void)recycleCoin
{
    [_moneySelImgView removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _playNum = 0;
        _playNumLab.text = [NSString stringWithFormat:@"%@%d",playNumPrefix,_playNum];
        _choosePlayLabel.text = [NSString stringWithFormat:@"%@%@",choosePlayPrefix,notChoosePlayStr];
        _choosePorB = 0;
        aaa1 = 0;
        aaa2 = 0;
        aaa3 = 0;
        bbb1 = 0;
        bbb2 = 0;
        bbb3 = 0;
        ccc1 = 0;
        ccc2 = 0;
        ccc3 = 0;
        _mycard1.image = [UIImage imageNamed:@""];
        _mycard2.image = [UIImage imageNamed:@""];
        _zhuangcard1.image = [UIImage imageNamed:@""];
        _zhuangcard2.image = [UIImage imageNamed:@""];
        _playerBtn.userInteractionEnabled = YES;
        _bankerBtn.userInteractionEnabled = YES;
        _tieBtn.userInteractionEnabled = YES;
        //_pairBtn.userInteractionEnabled = YES;
        
//        [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateNormal];
//        [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateHighlighted];
//        [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateNormal];
//        [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateHighlighted];
//        [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateNormal];
//        [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateHighlighted];
        
        [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        
//        for (UIImageView *img in _left100Arr) {
//            [UIView animateWithDuration:LeftTimes*2 animations:^{
//                img.frame = _gold_100Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });
//        }
//        [_left100Arr removeAllObjects];
//        for (UIImageView *img in _left500Arr) {
//            [UIView animateWithDuration:LeftTimes*2 animations:^{
//                img.frame = _gold_200Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });                }
//        [_left500Arr removeAllObjects];
//        for (UIImageView *img in _left1000Arr) {
//            [UIView animateWithDuration:LeftTimes*2 animations:^{
//                img.frame = _gold_300Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });                }
//        [_left1000Arr removeAllObjects];
//        for (UIImageView *img in _right100Arr) {
//            [UIView animateWithDuration:RightTimes animations:^{
//                img.frame = _gold_100Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });                }
//        [_right100Arr removeAllObjects];
//        for (UIImageView *img in _right500Arr) {
//            [UIView animateWithDuration:RightTimes animations:^{
//                img.frame = _gold_200Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });                }
//        [_right500Arr removeAllObjects];
//        for (UIImageView *img in _right1000Arr) {
//            [UIView animateWithDuration:RightTimes animations:^{
//                img.frame = _gold_300Img.frame;
//            }];
//            if (_isPlaymusic == YES) {
//                [AudioUtils play:@"ce_chip"];
//            }else{
//                
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [img removeFromSuperview];
//            });                }
//        [_right1000Arr removeAllObjects];
        //_playImg.userInteractionEnabled = YES;
    });

}

#pragma mark -- 闲家点击事件

- (IBAction)playerBtnClick:(UIButton *)sender
{
    if (_isPlaymusic == YES) {
        [AudioUtils play:@"Players_cn"];
    }else{
        
    }
    
    [_playerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_sel"] forState:UIControlStateNormal];
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_sel"] forState:UIControlStateHighlighted];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateNormal];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateHighlighted];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateNormal];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateHighlighted];
    _choosePorB = 1;
    [self setChoosePlayLabelText];
}

#pragma mark -- 庄家点击事件

- (IBAction)bankerBtnClick:(UIButton *)sender
{
    if (_isPlaymusic == YES) {
        [AudioUtils play:@"Bankers_cn"];
    }else{
        
    }
    
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_bankerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_bankerBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_tieBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateNormal];
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateHighlighted];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_sel"] forState:UIControlStateNormal];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_sel"] forState:UIControlStateHighlighted];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateNormal];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_nor"] forState:UIControlStateHighlighted];
    _choosePorB = 2;
    [self setChoosePlayLabelText];
}

#pragma mark -- tie点击事件

- (IBAction)tieBtnClick:(UIButton *)sender
{
    if (_isPlaymusic == YES) {
        [AudioUtils play:@"Bankers_cn"];
    }else{
        
    }
    
    
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_playerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_bankerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [_tieBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_tieBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    [_pairBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateNormal];
//    [_playerBtn setBackgroundImage:[UIImage imageNamed:@"xian_nor"] forState:UIControlStateHighlighted];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateNormal];
//    [_bankerBtn setBackgroundImage:[UIImage imageNamed:@"zhuang_nor"] forState:UIControlStateHighlighted];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_sel"] forState:UIControlStateNormal];
//    [_tieBtn setBackgroundImage:[UIImage imageNamed:@"tie_sel"] forState:UIControlStateHighlighted];
    _choosePorB = 3;
    [self setChoosePlayLabelText];
}

#pragma mark -- pair点击事件

//- (IBAction)pairBtnClick:(UIButton *)sender
//{
//    if (_isPlaymusic == YES) {
//        [AudioUtils play:@"Bankers_cn"];
//    }else{
//        
//    }

//    [_pairBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
//    [_playerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_bankerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_tieBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _choosePorB = 4;
//}

//关闭音乐
- (IBAction)closeMusic:(id)sender
{
    static NSInteger aaa = 0;
    if (aaa%2 == 0) {
        //_closeMusicImg.image = [UIImage imageNamed:@"对号1"];
        [_musicBtn setBackgroundImage:[UIImage imageNamed:@"musicClose"] forState:UIControlStateNormal];
        [_musicBtn setBackgroundImage:[UIImage imageNamed:@"musicClose"] forState:UIControlStateHighlighted];
        [_player stop];
    }else{
        //_closeMusicImg.image = [UIImage imageNamed:@"空1"];
        [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music"] forState:UIControlStateNormal];
        [_musicBtn setBackgroundImage:[UIImage imageNamed:@"music"] forState:UIControlStateHighlighted];
        [_player play];
    }
    aaa ++;
}


-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithArray:_pokersArr];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=4;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}
@end

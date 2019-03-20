library flutter_toast_loading;
import 'package:flutter/material.dart';
class FlutterToastLoading extends StatelessWidget{
    //子布局
    final Widget child;

    //加载中是否显示
    final bool loading;

    //进度提醒内容
    final String text;

    //文字样式
    final TextStyle textStyle;

    //加载中动画
    final Widget indicator;

    //加载动画的size
    final Size indicatorSize;

    //背景透明度
    final double backgroundColorAlpha;

    //有提示文字时的padding
    final double borderRadius;

    //有提示文字时的padding
    final double containerPadding;

    //文字的padding
    final EdgeInsets textPadding;

    //背影颜色
    final Color backgroundColor;


    FlutterToastLoading(
        {Key key,
            @required this.loading,
            this.text,
            this.textStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
            this.indicatorSize = const Size(100.0, 20.0),
            this.indicator, // DefaultProgressIndicator or CircularProgressIndicator or flutter_spinkit
            this.backgroundColor = Colors.black87,
            this.backgroundColorAlpha = 0.6,
            this.borderRadius = 4.0,
            this.containerPadding = 20.0,
            this.textPadding = const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
            @required this.child})
        : assert(child != null),
            assert(loading != null),
            super(key: key);

    @override
    Widget build(BuildContext context) {
        List<Widget> _list = [child];
        Widget progressIndicator = indicator ?? DefaultProgressIndicator(size: indicatorSize,);
        if (loading) {
            Widget progress;
            if (text == null) {
                progress = Center(
                    child: progressIndicator,
                );
            } else {
                progress = Center(
                    child: Container(
                        padding: EdgeInsets.all(containerPadding),
                        decoration: BoxDecoration(
                            color: this.backgroundColor,
                            borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                progressIndicator,
                                Container(
                                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                    child: Text(
                                        text,
                                        style: textStyle,
                                    ),
                                )
                            ],
                        ),
                    ),
                );
            }
            // 背景颜色
            _list.add(Opacity(
                opacity: backgroundColorAlpha,
                child: ModalBarrier(color: this.backgroundColor),
            ));
            _list.add(progress);
        }
        return Stack(
            children: _list,
        );
    }
}

// from https://github.com/While1true/flutter_refresh/blob/master/lib/Progress.dart
class DefaultProgressIndicator extends StatefulWidget {
    final Size size;
    final Color color;
    final int count;
    final int milliseconds;

    const DefaultProgressIndicator({
        this.size,
        this.milliseconds: 300,
        this.color: Colors.green,
        this.count: 4
    });

    @override
    State<StatefulWidget> createState() => _DefaultProgressState();

}

class _DefaultProgressState extends State<DefaultProgressIndicator> with TickerProviderStateMixin {

    List<Animation<double>> animators = [];
    List<AnimationController> _animationControllers = [];
    Size size;
    @override
    void initState() {
        super.initState();
        for (int i = 0; i < widget.count; i++) {

            var animationController = AnimationController(vsync: this,
                duration: Duration(milliseconds: widget.milliseconds * widget.count));
            animationController.value=0.8*i/widget.count;
            _animationControllers.add(animationController);
            Animation<double> animation = Tween(begin: 0.1, end: 1.9).animate(
                animationController);
            animators.add(animation);
        }
        animators[0].addListener(_change);
        try {
            var mi = (widget.milliseconds~/(2*animators.length-2));
            for (int i = 0; i < animators.length; i++) {
                onDelay(_animationControllers[i], mi*i);
            }
        } on Exception {

        }

    }

    void onDelay(AnimationController _animationControllers,
        int delay) async{
        Future.delayed(Duration(milliseconds: delay),(){
            _animationControllers..repeat().orCancel;
        });
    }

    void _change() {
        setState(() {});
    }

    @override
    Widget build(BuildContext context) {
        size = widget.size ?? Size(100.0, 20.0);
        return CustomPaint(
            painter: _ProgressPainter(
                animators: animators,
                color: widget.color,
                count: widget.count,
            ),
            size: size,
        );
    }

    @override
    void dispose() {
        super.dispose();
        animators[0].removeListener(_change);
        _animationControllers[0].dispose();
    }
}

class _ProgressPainter extends CustomPainter {
    final Color color;
    final int count;
    final List<Animation<double>>animators;

    const _ProgressPainter({this.animators, this.color, this.count});

    @override
    void paint(Canvas canvas, Size size) {
        var radius = size.width / (3 * count + 1);
        var paint = Paint()
            ..color = color
            ..style = PaintingStyle.fill;
        for (int i = 1; i < count + 1; i++) {
            double value = animators[i - 1].value;
            canvas.drawCircle(
                Offset(radius * i * 3 - radius, size.height / 2),
                radius * (value > 1 ? (2 - value) : value), paint);
        }
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
        return oldDelegate != this;
    }

}
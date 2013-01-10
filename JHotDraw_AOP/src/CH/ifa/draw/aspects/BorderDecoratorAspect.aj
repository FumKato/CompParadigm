package CH.ifa.draw.aspects;

import java.awt.Insets;

public privileged aspect BorderDecoratorAspect {
	declare precedence: BorderDecorator, DecoratorFigureAspect;

	private Point CH.ifa.draw.figures.Figure.myBorderOffset;
	private Color CH.ifa.draw.figures.Figure.myBorderColor;
	private Color CH.ifa.draw.figures.Figure.myShadowColor;
	
	public void CH.ifa.draw.figures.BorderDecorator.setBorderOffset(Point newBorderOffset) {
		//newBorderOffset = new Point(3, 3);
		myBorderOffset = newBorderOffset;
	}
	
	public Point CH.ifa.draw.figures.BorderDecorator.getBorderOffset() {
		if (myBorderOffset == null) {
			return new Point(0,0);
		} else {
			return myBorderOffset;
		}
	}
	
	pointcut initialize(BorderDecorator decorator): execution(CH.ifa.draw.figures.BorderDecorator.initialize()) && this(decorator);
	pointcut draw(BorderDecorator decorator, Graphics g): execution(CH.ifa.draw.figures.BorderDecorator.draw(g)) && this(decorator) &&Å@args(g);
	pointcut displayBox(BorderDecorator decorator): execution(CH.ifa.draw.figures.BorderDecorator.displayBox()) && this(decorator);
	pointcut connectionInsets(BorderDecorator decorator):execution(CH.ifa.draw.figures.BorderDecorator.connectionInsets()) && this(decorator);
	
	void around(BorderDecorator decorator): initialize(decorator) {
		decorator.setBorderOffset(new Point(3,3));
	}
	
	void around(BorderDecorator decorator, Graphics g): draw(decorator, g) {
		Rectangle r = decorator.displayBox();
		proceed(decorator, g);
		g.setColor(Color.white);
		g.drawLine(r.x, r.y, r.x, r.y + r.height);
		g.drawLine(r.x, r.y, r.x + r.width, r.y);
		g.setColor(Color.gray);
		g.drawLine(r.x + r.width, r.y, r.x + r.width, r.y + r.height);
		g.drawLine(r.x , r.y + r.height, r.x + r.width, r.y + r.height);
	}
	
	/**
	 * Gets the displaybox including the border.
	 */
	Rectangle around(BorderDecorator decorator): displayBox(decorator) {
		Rectangle r = decorator.fComponent.displayBox();
		r.grow(decorator.getBorderOffset().x, decorator.getBorderOffset().y);
		return r;
	}
	
	Insets around(BorderDecorator decorator): connectionInsets(decorator) {
		Insets i = decorator.super.connectionInsets();
		i.top -= decorator.getBorderOffset().y;
		i.bottom -= decorator.getBorderOffset().y;
		i.left -= decorator.getBorderOffset().x;
		i.right -= decorator.getBorderOffset().x;

		return i;
	}
}

package CH.ifa.draw.aspects;

import java.awt.Color;
import java.awt.Point;

public privileged aspect BorderDecoratorAspect {
	declare precedence: BorderDecoratorAspect, DecoratorFigureAspect;

	private static final long serialVersionUID = 1205601808259084917L;
	private int borderDecoratorSerializedDataVersion = 1;

	private Point CH.ifa.draw.figures.Figure.myBorderOffset;
	private Color CH.ifa.draw.figures.Figure.myBorderColor;
	private Color CH.ifa.draw.figures.Figure.myShadowColor;
	
	public void CH.ifa.draw.figures.Figure.setBorderOffset(Point newBorderOffset) {
		//newBorderOffset = new Point(3, 3);
		myBorderOffset = newBorderOffset;
	}
	
	public Point CH.ifa.draw.figures.Figure.getBorderOffset() {
		if (myBorderOffset == null) {
			return new Point(0,0);
		} else {
			return myBorderOffset;
		}
	}
	
	private boolean CH.ifa.draw.framework.Figure.isBorderDecorate = false;
	
	
}

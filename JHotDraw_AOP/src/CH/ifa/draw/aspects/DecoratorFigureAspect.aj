package CH.ifa.draw.aspects;

import java.awt.Graphics;
import java.awt.Insets;
import java.awt.Point;
import java.awt.Rectangle;
import java.util.Vector;

import CH.ifa.draw.framework.Connector;
import CH.ifa.draw.framework.Figure;
import CH.ifa.draw.framework.FigureEnumeration;
import CH.ifa.draw.framework.Locator;

public privileged aspect DecoratorFigureAspect {	
	/**
	 * The decorated figure.
	 */
	protected Figure CH.ifa.draw.standard.DecoratorFigure.fComponent;
	
	/**
	 * Decorates the given figure.
	 */
	public void CH.ifa.draw.standard.DecoratorFigure.decorate(Figure figure) {
		fComponent = figure;
		fComponent.addToContainer(this);
	}
	
	pointcut decoratorGenerated(DecoratorFigure decorator, Figure figure): execution(CH.ifa.draw.standard.DecoratorFigure.new(Figure)) && this(decorator) && args(figure);
	pointcut connectionInsets(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.connectionInsets()) && this(decorator);
	pointcut canConnect(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.canConnect()) && this(decorator);
	pointcut containsPoint(DecoratorFigure decorator, int x, int y): execution(CH.ifa.draw.standard.DecoratorFigure+.containsPoint(x, y)) && this(decorator) && args(x, y);
	pointcut peelDecoration(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.peelDecoration()) && this(decorator);
	pointcut displayBox(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.displayBox()) && this(decorator);
	pointcut basicDisplayBox(DecoratorFigure decorator, Point origin, Point corner): execution(CH.ifa.draw.standard.DecoratorFigure+.basicDisplayBox(origin, corner)) && this(decorator) && args(origin, corner);
	pointcut draw(DecoratorFigure decorator, Graphics g): execution(CH.ifa.draw.standard.DecoratorFigure+.draw(g)) && this(decorator) && args(g);
	pointcut findFigureInside(DecoratorFigure decorator, int x, int y): execution(CH.ifa.draw.standard.DecoratorFigure+.findFigureInside(x, y)) && this(decorator) && args(x, y);
	pointcut handles(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.handles()) && this(decorator);
	pointcut includes(DecoratorFigure decorator, Figure figure): execution(CH.ifa.draw.standard.DecoratorFigure+.includes(figure)) && this(decorator) && args(figure);
	pointcut moveBy(DecoratorFigure decorator, int x, int y): execution(CH.ifa.draw.standard.DecoratorFigure+.moveBy(x, y)) && this(decorator) && args(x, y);
	pointcut release(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.release()) && this(decorator);
	pointcut figures(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.figures()) && this(decorator);
	pointcut decompose(DecoratorFigure decorator): execution(CH.ifa.draw.standard.DecoratorFigure+.decompose()) && this(decorator);
	pointcut setAttribute(DecoratorFigure decorator, String name, Object value): execution(CH.ifa.draw.standard.DecoratorFigure+.setAttribute(name, value)) && this(decorator) && args(name, value);
	pointcut getAttribute(DecoratorFigure decorator, String name): execution(CH.ifa.draw.standard.DecoratorFigure+.getAttribute(name)) && this(decorator) && args(name);
	pointcut connectedTextLocator(DecoratorFigure decorator, Figure text): execution(CH.ifa.draw.standard.DecoratorFigure+.connectedTextLocator(text)) && this(decorator) && args(text);
	pointcut connectorAt(DecoratorFigure decorator, int x, int y):  execution(CH.ifa.draw.standard.DecoratorFigure+.connectorAt(x, y)) && this(decorator) && args(x, y);
	pointcut connectorVisibility(DecoratorFigure decorator, boolean isVisible): execution(CH.ifa.draw.standard.DecoratorFigure+.connectorVisibility(isVisible)) && this(decorator) && args(isVisible);
	
	after(DecoratorFigure decorator, Figure figure) returning: decoratorGenerated(decorator, figure) {
		decorator.decorate(figure);
	}
	
	/**
	 * Forwards the connection insets to its contained figure..
	 */
	Insets around(DecoratorFigure decorator): connectionInsets(decorator) {
		return decorator.fComponent.connectionInsets();
	}
	
	/**
	 * Forwards the canConnect to its contained figure..
	 */
	boolean around(DecoratorFigure decorator): canConnect(decorator) {
		return decorator.fComponent.canConnect();
	}
	
	/**
	 * Forwards containsPoint to its contained figure.
	 */
	boolean around(DecoratorFigure decorator, int x, int y): containsPoint(decorator, x, y) {
		return decorator.fComponent.containsPoint(x, y);
	}
	
	/**
	 * Removes the decoration from the contained figure.
	 */
	Figure around(DecoratorFigure decorator): peelDecoration(decorator) {
		decorator.fComponent.removeFromContainer(this); //??? set the container to the listener()?
		return decorator.fComponent;
	}
	
	/**
	 * Forwards displayBox to its contained figure.
	 */
	Rectangle around(DecoratorFigure decorator): displayBox(decorator) {
		return decorator.fComponent.displayBox();
	}
	
	/**
	 * Forwards basicDisplayBox to its contained figure.
	 */
	void around(DecoratorFigure decorator, Point origin, Point corner): basicDisplayBox(decorator, origin, corner) {
		decorator.fComponent.basicDisplayBox(origin, corner);
	}
	
	/**
	 * Forwards draw to its contained figure.
	 */
	void around(DecoratorFigure decorator, Graphics g): draw(decorator, g) {
		decorator.fComponent.draw(g);
	}
	
	/**
	 * Forwards findFigureInside to its contained figure.
	 */
	Figure around(DecoratorFigure decorator, int x, int y): findFigureInside(decorator, x, y) {
		return decorator.fComponent.findFigureInside(x, y);
	}
	
	/**
	 * Forwards handles to its contained figure.
	 */
	Vector around(DecoratorFigure decorator): handles(decorator) {
		return decorator.fComponent.handles();
	}
	
	/**
	 * Forwards includes to its contained figure.
	 */
	boolean around(DecoratorFigure decorator, Figure figure): includes(decorator, figure) {
		return (decorator.super.includes(figure) || decorator.fComponent.includes(figure));
	}
	
	/**
	 * Forwards moveBy to its contained figure.
	 */
	void around(DecoratorFigure decorator, int x, int y): moveBy(decorator, x, y) {
		decorator.fComponent.moveBy(x, y);
	}
	
	/**
	 * Releases itself and the contained figure.
	 */
	void around(DecoratorFigure decorator): release(decorator) {
		decorator.super.release();
		decorator.fComponent.removeFromContainer(this);
		decorator.fComponent.release();
	}
	
	/**
	 * Forwards figures to its contained figure.
	 */
	FigureEnumeration around(DecoratorFigure decorator): figures(decorator) {
		return decorator.fComponent.figures();
	}
	
	/**
	 * Forwards decompose to its contained figure.
	 */
	FigureEnumeration around(DecoratorFigure decorator): decompose(decorator) {
		return decorator.fComponent.decompose();
	}
	
	/**
	 * Forwards setAttribute to its contained figure.
	 */
	void around(DecoratorFigure decorator, String name, Object value): setAttribute(decorator, name, value) {
		decorator.fComponent.setAttribute(name, value);
	}
	
	/**
	 * Forwards getAttribute to its contained figure.
	 */
	Object around(DecoratorFigure decorator, String name): getAttribute(decorator, name) {
		return decorator.fComponent.getAttribute(name);
	}
	
	/**
	 * Returns the locator used to located connected text.
	 */
	Locator around(DecoratorFigure decorator, Figure text): connectedTextLocator(decorator, text) {
		return decorator.fComponent.connectedTextLocator(text);
	}
	
	/**
	 * Returns the Connector for the given location.
	 */
	Connector around(DecoratorFigure decorator, int x, int y): connectorAt(decorator, x, y) {
		return decorator.fComponent.connectorAt(x, y);
	}
	
	/**
	 * Forwards the connector visibility request to its component.
	 */
	void around(DecoratorFigure decorator, boolean isVisible): connectorVisibility(decorator, isVisible) {
		decorator.fComponent.connectorVisibility(isVisible);
	}
}

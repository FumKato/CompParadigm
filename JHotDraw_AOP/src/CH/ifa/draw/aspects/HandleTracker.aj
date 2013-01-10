package CH.ifa.draw.aspects;

import java.awt.event.MouseEvent;

import CH.ifa.draw.standard.AbstractTool;

public privileged aspect HandleTracker {
	
	public interface AbstractHandleTracker {};
	
	private Handle AbstractHandleTracker.fAnchorHandle;
	private boolean AbstractHandleTracker.isHandleTracker = false;
	
	declare parents: CH.ifa.draw.standard.AbstractTool implements AbstractHandleTracker;
	
	pointcut selectionHandleTrackerUsed(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.view().findHandle(e.getX(), e.getY()) != null);
	pointcut selectionMouseDowned(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDown(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);
	pointcut selectionMouseDraged(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);
	pointcut selectionMouseUpped(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseUp(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);	
	
	pointcut dragNDropHandleTrakcerUsed(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.contrib.DragNDropTool.mouseDown(e,x,y)) && this(tool) && args(e, x, y) && if(tool.view().findHandle(e.getX(), e.getY()) != null);
	pointcut dragNDropMouseDowned(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.DragNDropTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);
	pointcut dragNDropMouseDraged(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.DragNDropTool.mouseDrag(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);
	pointcut dragNDropMouseUpped(AbstractTool tool, MouseEvent e, int x, int y): execution(void CH.ifa.draw.standard.SelectionTool.mouseUp(e, x, y)) && this(tool) && args(e, x, y) && if(tool.isHandleTracker);	
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionHandleTrackerUsed(tool, e, x, y) {
		tool.fAnchorHandle = tool.view().findHandle(e.getX(), e.getY());
		tool.isHandleTracker = true;
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): dragNDropHandleTrackerUsed(tool, e, x, y) {
		tool.isHandleTracker = true;
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDowned(tool, e, x, y) {
		tool.fAnchorHandle = tool.view().findHandle(e.getX(), e.getY());
		tool.super.mouseDown(e, x, y);
		fAnchorHandle.invokeStart(x, y, view());
		//activate();
	}
	
	void around(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseDraged(tool, e, x, y) {
		tool.super.mouseDrag(e, x, y);
		tool.fAnchorHandle.invokeStep(x, y, tool.fAnchorX, tool.fAnchorY, view());
	}

	after(AbstractTool tool, MouseEvent e, int x, int y): selectionMouseUpped(tool, e, x, y) {
		tool.super.mouseUp(e, x, y);
		tool.fAnchorHandle.invokeEnd(x, y, fAnchorX, fAnchorY, view());
		tool.super.deactivate();
		tool.fChildExistence = false;
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y): dragNDropMouseDowned(tool, e, x, y) {
		tool.fAnchorHandle = tool.view().findHandle(e.getX(), e.getY());
		tool.super.mouseDown(e, x, y);
		fAnchorHandle.invokeStart(x, y, view());
	}
	
	void around(AbstractTool tool, MouseEvent e, int x, int y): dragNDropMouseDraged(tool, e, x, y) {
		tool.super.mouseDrag(e, x, y);
		tool.fAnchorHandle.invokeStep(x, y, tool.fAnchorX, tool.fAnchorY, view());
	}
	
	after(AbstractTool tool, MouseEvent e, int x, int y): dragNDropMouseUpped(tool, e, x, y) {
		tool.super.mouseUp(e, x, y);
		tool.fAnchorHandle.invokeEnd(x, y, fAnchorX, fAnchorY, view());
		tool.fChildExistence = false;
	}
}

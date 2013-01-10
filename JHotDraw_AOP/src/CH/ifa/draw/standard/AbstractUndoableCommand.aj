package CH.ifa.draw.standard;

import CH.ifa.draw.framework.*;
import CH.ifa.draw.util.CommandListener;
import java.util.*;

public abstract class AbstractUndoableCommand extends AbstractCommand implements CommandListener {
	
	/*����private, protected*/public boolean hasSelectionChanged;
	
	public AbstractUndoableCommand(String newName, DrawingEditor newDrawingEditor) {
		super(newName, newDrawingEditor);
	}
	
	public void figureSelectionChanged(DrawingView view) {
		hasSelectionChanged = true;
	}
	
	public void commandExecuted(EventObject commandEvent) {
		getEventDispatcher().fireCommandExecutedEvent();
	}
	
	public void commandExecutable(EventObject commandEvent) {
		getEventDispatcher().fireCommandExecutableEvent();
	}
	
	public void commandNotExecutable(EventObject commandEvent) {
		getEventDispatcher().fireCommandNotExecutableEvent();
	}
}

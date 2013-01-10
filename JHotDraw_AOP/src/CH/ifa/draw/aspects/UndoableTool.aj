package CH.ifa.draw.aspects;

public privileged aspect UndoableTool {
	pointcut undoableDeactivate(AbstractUndoableTool undoabletool): execution(void CH.ifa.draw.util.AbstractUndoableTool+.deacitvate(..)) && this(undoabletool);
	
	public around(AbstractUndoableTool undoabletool): undoableDeactivate(undoabletool){
		proceed(undoabletool);
		Undoable undoActivity = undoabletool.getUndoActivity();
		if ((undoActivity != null) && (undoActivity.isUndoable())) {
			undoabletool.editor().getUndoManager().pushUndo(undoActivity);
			undoabletool.editor().getUndoManager().clearRedos();
			// update menus
			undoabletool.editor().figureSelectionChanged(view());
		}
	}
}

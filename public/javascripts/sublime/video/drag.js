S2.UI.Behavior.TransformDrag = Class.create(S2.UI.Behavior, {
  initialize: function($super, element, options) {
    this.__onmousemove = this._onmousemove.bind(this);
    $super(element, options);
    this.element.addClassName('ui-draggable');
    
    // Jilion
    this.element.setStyle({
      WebkitTransform:'translate(0px,0px)',
      MozTransform:'translate(0px,0px)'
    });
  },

  destroy: function($super) {
    this.element.removeClassName('ui-draggable');
    $super();
  },

  "handle/onmousedown": function(event) {
    if (event.element().hasClassName('ui-draggable')) {
      var element = this.element;
      // Jilion
      var matrixRegexp = /.*translate\(\s*(-*[0-9]*)px\s*,*\s*(-*[0-9]*)px\s*\)/;
      var tranformMatrix = element.getStyle('WebkitTransform') || element.getStyle("MozTransform");
      this._startPointer  = event.pointer();
      this._startPosition = {
        left: window.parseInt(tranformMatrix.match(matrixRegexp)[1], 10),
        top:  window.parseInt(tranformMatrix.match(matrixRegexp)[2],  10)
        // left: window.parseInt(element.getStyle('left'), 10),
        // top:  window.parseInt(element.getStyle('top'),  10)
      };
      document.observe('mousemove', this.__onmousemove);
    }
  },

  "handle/onmouseup": function(event) {
    this._startPointer  = null;
    this._startPosition = null;
    document.stopObserving('mousemove', this.__onmousemove);
  },

  _onmousemove: function(event) {
    var pointer = event.pointer();

    if (!this._startPointer) return;

    var delta = {
      x: pointer.x - this._startPointer.x,
      y: pointer.y - this._startPointer.y
    };
    
    // var newPosition = {
    //   left: (this._startPosition.left + delta.x) + 'px',
    //   top:  (this._startPosition.top  + delta.y) + 'px'
    // };
    // this.element.setStyle(newPosition);
    
    // Jilion
    var translateValue = 'translate('+ (this._startPosition.left + delta.x) + 'px, ' + (this._startPosition.top  + delta.y) + 'px)';
    var newTransformedPosition = {
      WebkitTransform: translateValue,
      MozTransform: translateValue
    };
    this.element.setStyle(newTransformedPosition);
  }
});
jsToolBar.prototype.elements.strong = {
	type: 'button',
	title: 'Strong',
	fn: {
		wiki: function()  { this.encloseSelection("\\textbf{", "}") }
	}
}

// em
jsToolBar.prototype.elements.em = {
	type: 'button',
	title: 'Italic',
	fn: {
		wiki: function()  { this.encloseSelection("\\textit{", "}") }
	}
}

// ins
jsToolBar.prototype.elements.ins = {
	type: 'button',
	title: 'Underline',
	fn: {
		wiki: function() { this.encloseSelection("\\underline{", "}") }
	}
}



// code
jsToolBar.prototype.elements.code = {
	type: 'button',
	title: 'Math',
	fn: {
		wiki: function() { this.singleTag('$') }
	}
}

// spacer
jsToolBar.prototype.elements.space1 = {type: 'space'}

// headings
jsToolBar.prototype.elements.h1 = {
	type: 'button',
	title: 'Part',
	fn: {
		wiki: function() { this.encloseSelection("\\part{", "}") }
	}
}
jsToolBar.prototype.elements.h2 = {
	type: 'button',
	title: 'Part',
	fn: {
		wiki: function() { this.encloseSelection("\\chapter{", "}") }
	}
}

jsToolBar.prototype.elements.h2 = {
	type: 'button',
	title: 'Part',
	fn: {
		wiki: function() { this.encloseSelection("\\section{", "}") }
	}
}

// spacer
jsToolBar.prototype.elements.space2 = {type: 'space'}

// ul
jsToolBar.prototype.elements.ul = {
	type: 'button',
	title: 'Unordered list',
	fn: {
		wiki: function() {
			this.encloseLineSelection('\\begin{itemize}','\n\\end{itemize}',function(str) {
				str = str.replace(/\r/g,'');
				return str.replace(/(\n|^)[#-]?\s*/g,"$1  \\item  ");
			});
		}
	}
}

// ol
jsToolBar.prototype.elements.ol = {
	type: 'button',
	title: 'Ordered list',
	fn: {
		wiki: function() {
			this.encloseLineSelection('\\begin{enumerate}','\n\\end{enumerate}',function(str) {
				str = str.replace(/\r/g,'');
				return str.replace(/(\n|^)[#-]?\s*/g,"$1  \\item  ");
			});
		}
	}
}

// spacer
jsToolBar.prototype.elements.space3 = {type: 'space'}



// wiki page
jsToolBar.prototype.elements.link = {
	type: 'button',
	title: 'Include',
	fn: {
		wiki: function() { this.encloseSelection("\\input{", "}") }
	}
}
// image
jsToolBar.prototype.elements.img = {
	type: 'button',
	title: 'Image',
	fn: {
          wiki: function() { this.encloseSelection("\\includegraphics[width=125mm]{","}") }
	}
}

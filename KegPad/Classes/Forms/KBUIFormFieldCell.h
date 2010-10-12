//
//  KBUIFormFieldCell.h
//  KegPad
//
//  Created by Gabe on 9/28/10.
//  Copyright 2010 rel.me. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

@interface KBUIFormFieldCell : UITableViewCell {

	UITextField *textField_;
  
  BOOL editable_;

}

@property (readonly, nonatomic) UITextField *textField;
@property (assign, nonatomic, getter=isEditable) BOOL editable;

@end

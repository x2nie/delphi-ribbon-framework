unit UIRibbonActions;

interface

uses
  Classes,
  ActnList,
  UIRibbonCommands;

type
  TUICommandActionLink = class abstract (TActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    FClient: TUICommand;
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure AssignClient(AClient: TObject); override;
    function IsEnabledLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    procedure SetCaption(const Value: String); override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetHint(const Value: String); override;
    procedure SetOnExecute(Value: TNotifyEvent); override;

    property Client: TUICommand read FClient;
  public
    constructor Create(const AClient: TUICommand); reintroduce;
  end;

  TUICommandEmptyActionLink = class(TUICommandActionLink)
    { No additional declarations }
  end;

  TUICommandActionActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandExecute(const Args: TUICommandActionEventArgs);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

  TUICommandCollectionActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandSelect(const Args: TUICommandCollectionEventArgs);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

  TUICommandDecimalActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandChange(const Command: TUICommandDecimal;
      const Verb: TUICommandVerb; const Value: Double;
      const Properties: TUICommandExecutionProperties);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

  TUICommandBooleanActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandToggle(const Args: TUICommandBooleanEventArgs);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
    procedure SetChecked(Value: Boolean); override;
  end;

  TUICommandFontActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandChanged(const Args: TUICommandFontEventArgs);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

  TUICommandColorAnchorActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandExecute(const Args: TUICommandColorEventArgs);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

  TUICommandRecentItemsActionLink = class(TUICommandActionLink)
  {$REGION 'Internal Declarations'}
  strict private
    procedure CommandSelect(const Command: TUICommandRecentItems;
      const Verb: TUICommandVerb; const ItemIndex: Integer;
      const Properties: TUICommandExecutionProperties);
  {$ENDREGION 'Internal Declarations'}
  protected
    procedure SetAction(Value: TBasicAction); override;
  end;

implementation

uses
  Menus;

{ TUICommandActionLink }

procedure TUICommandActionLink.AssignClient(AClient: TObject);
begin
  inherited;
  FClient := AClient as TUICommand;
end;

constructor TUICommandActionLink.Create(const AClient: TUICommand);
begin
  inherited Create(AClient);
end;

function TUICommandActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and (FClient.Enabled = (Action as TCustomAction).Enabled);
end;

function TUICommandActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := False;
end;

procedure TUICommandActionLink.SetCaption(const Value: String);
begin
  if IsCaptionLinked and (Value <> '') then
    FClient.Caption := Value;
end;

procedure TUICommandActionLink.SetEnabled(Value: Boolean);
begin
  if IsEnabledLinked then
    FClient.Enabled := Value;
end;

procedure TUICommandActionLink.SetHint(const Value: String);
var
  I: Integer;
begin
  if IsHintLinked then
  begin
    I := Pos('|', Value);
    if (I = 0) then
      FClient.TooltipTitle := Value
    else
    begin
      FClient.TooltipTitle := Copy(Value, 1, I - 1);
      FClient.TooltipDescription := Copy(Value, I + 1, MaxInt);
    end;
  end;
end;

procedure TUICommandActionLink.SetOnExecute(Value: TNotifyEvent);
begin
  { No implementation }
end;

{ TUICommandActionActionLink }

procedure TUICommandActionActionLink.CommandExecute(
  const Args: TUICommandActionEventArgs);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandActionActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandAction).OnExecute := CommandExecute;
end;

{ TUICommandCollectionActionLink }

procedure TUICommandCollectionActionLink.CommandSelect(
  const Args: TUICommandCollectionEventArgs);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandCollectionActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandCollection).OnSelect := CommandSelect;
end;

{ TUICommandDecimalActionLink }

procedure TUICommandDecimalActionLink.CommandChange(
  const Command: TUICommandDecimal; const Verb: TUICommandVerb;
  const Value: Double; const Properties: TUICommandExecutionProperties);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandDecimalActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandDecimal).OnChange := CommandChange;
end;

{ TUICommandBooleanActionLink }

procedure TUICommandBooleanActionLink.CommandToggle(
  const Args: TUICommandBooleanEventArgs);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandBooleanActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandBoolean).OnToggle := CommandToggle;
end;

procedure TUICommandBooleanActionLink.SetChecked(Value: Boolean);
begin
  inherited;
  (Client as TUICommandBoolean).Checked := Value;
end;

{ TUICommandFontActionLink }

procedure TUICommandFontActionLink.CommandChanged(
  const Args: TUICommandFontEventArgs);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandFontActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandFont).OnChanged := CommandChanged;
end;

{ TUICommandColorAnchorActionLink }

procedure TUICommandColorAnchorActionLink.CommandExecute(
  const Args: TUICommandColorEventArgs);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandColorAnchorActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandColorAnchor).OnExecute := CommandExecute;
end;

{ TUICommandRecentItemsActionLink }

procedure TUICommandRecentItemsActionLink.CommandSelect(
  const Command: TUICommandRecentItems; const Verb: TUICommandVerb;
  const ItemIndex: Integer; const Properties: TUICommandExecutionProperties);
begin
  if Assigned(Action) then
    Action.Execute;
end;

procedure TUICommandRecentItemsActionLink.SetAction(Value: TBasicAction);
begin
  inherited;
  if Assigned(Value) then
    (Client as TUICommandRecentItems).OnSelect := CommandSelect;
end;

end.
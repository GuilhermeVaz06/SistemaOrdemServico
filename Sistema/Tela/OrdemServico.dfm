object FOrdemServico: TFOrdemServico
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Ordem de Servi'#231'o'
  ClientHeight = 614
  ClientWidth = 1363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PCTela: TPageControl
    Left = 0
    Top = 0
    Width = 1363
    Height = 614
    ActivePage = TBCadastro
    Align = alClient
    TabOrder = 0
    object TBCadastro: TTabSheet
      Caption = 'Cadastro'
      OnShow = TBCadastroShow
      object Painel: TPanel
        Left = 0
        Top = 0
        Width = 1355
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BFechar: TSpeedButton
          Left = 630
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Fechar'
          ImageIndex = 6
          Images = FMenuPrincipal.ImageList1
          OnClick = BFecharClick
          ExplicitLeft = 1237
        end
        object BConfirmar: TSpeedButton
          Left = 450
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Confirmar'
          ImageIndex = 5
          Images = FMenuPrincipal.ImageList1
          Enabled = False
          OnClick = BConfirmarClick
          ExplicitLeft = 517
        end
        object BCancelar: TSpeedButton
          Left = 360
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Cancelar'
          ImageIndex = 4
          Images = FMenuPrincipal.ImageList1
          Enabled = False
          OnClick = BCancelarClick
          ExplicitLeft = 418
        end
        object BAlterar: TSpeedButton
          Left = 180
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Alterar'
          ImageIndex = 1
          Images = FMenuPrincipal.ImageList1
          OnClick = BAlterarClick
          ExplicitLeft = 147
        end
        object BCadastrar: TSpeedButton
          Left = 90
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Cadastrar'
          ImageIndex = 0
          Images = FMenuPrincipal.ImageList1
          OnClick = BCadastrarClick
          ExplicitLeft = 79
          ExplicitTop = -6
        end
        object BImprimir: TSpeedButton
          Left = 540
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Imprimir'
          ImageIndex = 12
          Images = FMenuPrincipal.ImageList1
          ExplicitLeft = 1117
        end
        object BInativar: TSpeedButton
          Left = 270
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Excluir'
          ImageIndex = 2
          Images = FMenuPrincipal.ImageList1
          OnClick = BInativarClick
          ExplicitLeft = 277
        end
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 90
          Height = 29
          DataSource = FDMOrdemServico.DOrdemServico
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
          Align = alLeft
          TabOrder = 0
        end
      end
      object PInfo: TPanel
        Left = 0
        Top = 535
        Width = 1355
        Height = 48
        Align = alBottom
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 3
        object Label27: TLabel
          Left = 9
          Top = 0
          Width = 88
          Height = 16
          Caption = 'Cadastrado Por'
        end
        object Label28: TLabel
          Left = 199
          Top = 0
          Width = 71
          Height = 16
          Caption = 'Alterado Por'
        end
        object Label29: TLabel
          Left = 388
          Top = 0
          Width = 81
          Height = 16
          Caption = 'Data Cadastro'
        end
        object Label30: TLabel
          Left = 578
          Top = 0
          Width = 84
          Height = 16
          Caption = 'Data Altera'#231#227'o'
        end
        object DBEdit3: TDBEdit
          Left = 9
          Top = 17
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'cadastradoPor'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 0
        end
        object DBEdit13: TDBEdit
          Left = 199
          Top = 17
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'alteradoPor'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 1
        end
        object DBEdit15: TDBEdit
          Left = 388
          Top = 17
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'dataCadastro'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 2
        end
        object DBEdit16: TDBEdit
          Left = 578
          Top = 17
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'dataAlteracao'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 3
        end
      end
      object PCDados: TPageControl
        Left = 0
        Top = 283
        Width = 1355
        Height = 252
        ActivePage = TabResumo
        Align = alClient
        TabOrder = 2
        object TBItem: TTabSheet
          Caption = 'Servi'#231'os'
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarItem: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BCadastrarItemClick
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BRemoverItem: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BRemoverItemClick
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object GItem: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 175
            Align = alClient
            DataSource = FDMOrdemServico.DItem
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnDblClick = GItemDblClick
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'descricao'
                Title.Alignment = taCenter
                Title.Caption = 'Descri'#231#227'o'
                Width = 271
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'quantidade'
                Title.Alignment = taCenter
                Title.Caption = 'Quantidade'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorUnitario'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Unitario'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'desconto'
                Title.Alignment = taCenter
                Title.Caption = 'Desconto %'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorDesconto'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Desconto'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorFinal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Final'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
          object CBMostrarInativoItem: TCheckBox
            Left = 0
            Top = 204
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 2
            OnClick = CBMostrarInativoItemClick
          end
        end
        object TBProduto: TTabSheet
          Caption = 'Produtos'
          ImageIndex = 1
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarProduto: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BCadastrarProdutoClick
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BExcluirProduto: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BExcluirProdutoClick
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object CBInativoProduto: TCheckBox
            Left = 0
            Top = 204
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 2
            OnClick = CBInativoProdutoClick
          end
          object GProduto: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 175
            Align = alClient
            DataSource = FDMOrdemServico.DProduto
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnDblClick = GProdutoDblClick
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'descricao'
                Title.Alignment = taCenter
                Title.Caption = 'Descri'#231#227'o'
                Width = 170
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'unidade'
                Title.Alignment = taCenter
                Title.Caption = 'Unidade'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'quantidade'
                Title.Alignment = taCenter
                Title.Caption = 'Quantidade'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorUnitario'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Unitario'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'desconto'
                Title.Alignment = taCenter
                Title.Caption = 'Desconto %'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorDesconto'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Desconto'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorFinal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Final'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
        end
        object TabCusto: TTabSheet
          Caption = 'Custos Gerais'
          ImageIndex = 3
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarCusto: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BCadastrarCustoClick
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BExcluirCusto: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BExcluirCustoClick
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object GCusto: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 175
            Align = alClient
            DataSource = FDMOrdemServico.DCusto
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnDblClick = GCustoDblClick
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'descricao'
                Title.Alignment = taCenter
                Title.Caption = 'Descri'#231#227'o'
                Width = 170
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'subDescricao'
                Title.Alignment = taCenter
                Title.Caption = 'Sub Descri'#231#227'o'
                Width = 145
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'quantidade'
                Title.Alignment = taCenter
                Title.Caption = 'Quantidade'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorUnitario'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Unitario'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
          object CBInativoCusto: TCheckBox
            Left = 0
            Top = 204
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 2
            OnClick = CBInativoCustoClick
          end
        end
        object TabCustoFuncionario: TTabSheet
          Caption = 'Custo com Funcionarios'
          ImageIndex = 4
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BFuncionarioCadastrar: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BFuncionarioCadastrarClick
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BFuncionarioExcluir: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              OnClick = BFuncionarioExcluirClick
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object GFuncionario: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 175
            Align = alClient
            DataSource = FDMOrdemServico.DFuncionario
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnDblClick = GFuncionarioDblClick
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'descricao'
                Title.Alignment = taCenter
                Title.Caption = 'Descri'#231#227'o'
                Width = 170
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'nomeFuncionario'
                Title.Alignment = taCenter
                Title.Caption = 'Funcionario'
                Width = 145
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'qtdeHoraNormal'
                Title.Alignment = taCenter
                Title.Caption = 'Qtde Hora Normal'
                Width = 131
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorHoraNormal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Hora Normal'
                Width = 138
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotalNormal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total Normal'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'qtdeHora50'
                Title.Alignment = taCenter
                Title.Caption = 'Qtde Hora 50%'
                Width = 124
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorHora50'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Hora 50%'
                Width = 123
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal50'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total 50%'
                Width = 120
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'qtdeHora100'
                Title.Alignment = taCenter
                Title.Caption = 'Qtde Hora 100%'
                Width = 126
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorHora100'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Hora 100%'
                Width = 136
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal100'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total 100%'
                Width = 147
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'qtdeHoraAdNoturno'
                Title.Alignment = taCenter
                Title.Caption = 'Qtde Hora Ad. Noturno'
                Width = 147
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorHoraAdNoturno'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Hora Ad. Noturno'
                Width = 163
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotalAdNoturno'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total Ad. Noturno'
                Width = 172
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'valorTotal'
                Title.Alignment = taCenter
                Title.Caption = 'Valor Total'
                Width = 108
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
          object CBInativoFuncionario: TCheckBox
            Left = 0
            Top = 204
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 2
            OnClick = CBInativoFuncionarioClick
          end
        end
        object TabResumo: TTabSheet
          Caption = 'Resumo Financeiro'
          ImageIndex = 2
          OnShow = TabResumoShow
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 221
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object GValoresCusto: TDBGrid
              Left = 0
              Top = 118
              Width = 1347
              Height = 103
              Align = alClient
              DataSource = FDMOrdemServico.DCustoTotal
              ReadOnly = True
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -13
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              OnDrawColumnCell = GValoresCustoDrawColumnCell
              OnTitleClick = GDadosTitleClick
              Columns = <
                item
                  Expanded = False
                  FieldName = 'descricao'
                  Title.Alignment = taCenter
                  Title.Caption = 'Descri'#231#227'o'
                  Width = 323
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'subDescricao'
                  Title.Alignment = taCenter
                  Title.Caption = 'Itens'
                  Width = 138
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'quantidade'
                  Title.Alignment = taCenter
                  Title.Caption = 'Quantidade'
                  Width = 120
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'valorTotal'
                  Title.Alignment = taCenter
                  Title.Caption = 'Valor Total'
                  Width = 166
                  Visible = True
                end>
            end
            object GValoresOrdem: TDBGrid
              Left = 0
              Top = 0
              Width = 1347
              Height = 95
              Align = alTop
              DataSource = FDMOrdemServico.DValorTotal
              ReadOnly = True
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -13
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              OnDrawColumnCell = GValoresOrdemDrawColumnCell
              OnTitleClick = GDadosTitleClick
              Columns = <
                item
                  Expanded = False
                  FieldName = 'descricao'
                  Title.Alignment = taCenter
                  Title.Caption = 'Descri'#231#227'o'
                  Width = 326
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'valorBruto'
                  Title.Alignment = taCenter
                  Title.Caption = 'Valor Bruto'
                  Width = 135
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'desconto'
                  Title.Alignment = taCenter
                  Title.Caption = 'Desconto'
                  Width = 114
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'valorFinal'
                  Title.Alignment = taCenter
                  Title.Caption = 'Valor Final'
                  Width = 172
                  Visible = True
                end>
            end
            object Panel8: TPanel
              Left = 0
              Top = 95
              Width = 1347
              Height = 23
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 2
            end
          end
        end
      end
      object PDados: TPanel
        Left = 0
        Top = 58
        Width = 1355
        Height = 225
        Align = alTop
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 1
        object Label1: TLabel
          Left = 9
          Top = 9
          Width = 39
          Height = 16
          Caption = 'Codigo'
        end
        object Label2: TLabel
          Left = 90
          Top = 9
          Width = 50
          Height = 16
          Caption = 'Empresa'
        end
        object Label13: TLabel
          Left = 594
          Top = 9
          Width = 79
          Height = 16
          Caption = 'Detalhamento'
        end
        object Label3: TLabel
          Left = 9
          Top = 50
          Width = 39
          Height = 16
          Caption = 'Cliente'
        end
        object Label8: TLabel
          Left = 594
          Top = 137
          Width = 67
          Height = 16
          Caption = 'Observa'#231#227'o'
        end
        object Label9: TLabel
          Left = 277
          Top = 50
          Width = 53
          Height = 16
          Caption = 'Endere'#231'o'
        end
        object Label10: TLabel
          Left = 359
          Top = 50
          Width = 55
          Height = 16
          Caption = 'Descri'#231#227'o'
        end
        object Label11: TLabel
          Left = 451
          Top = 50
          Width = 22
          Height = 16
          Caption = 'CEP'
        end
        object Label12: TLabel
          Left = 9
          Top = 95
          Width = 72
          Height = 16
          Caption = 'Longradouro'
        end
        object Label14: TLabel
          Left = 208
          Top = 95
          Width = 45
          Height = 16
          Caption = 'Numero'
        end
        object Label15: TLabel
          Left = 290
          Top = 95
          Width = 34
          Height = 16
          Caption = 'Bairro'
        end
        object Label16: TLabel
          Left = 382
          Top = 95
          Width = 79
          Height = 16
          Caption = 'Complemento'
        end
        object Label18: TLabel
          Left = 9
          Top = 137
          Width = 39
          Height = 16
          Caption = 'Cidade'
        end
        object Label19: TLabel
          Left = 208
          Top = 137
          Width = 38
          Height = 16
          Caption = 'Estado'
        end
        object Label20: TLabel
          Left = 320
          Top = 137
          Width = 23
          Height = 16
          Caption = 'Pais'
        end
        object Label21: TLabel
          Left = 450
          Top = 137
          Width = 58
          Height = 16
          Caption = 'Finalidade'
        end
        object Label22: TLabel
          Left = 9
          Top = 179
          Width = 89
          Height = 16
          Caption = 'Transportadora'
        end
        object Label23: TLabel
          Left = 276
          Top = 179
          Width = 59
          Height = 16
          Caption = 'Tipo Frete'
        end
        object Label24: TLabel
          Left = 388
          Top = 8
          Width = 49
          Height = 16
          Caption = 'Situa'#231#227'o'
        end
        object Label25: TLabel
          Left = 476
          Top = 178
          Width = 80
          Height = 16
          Caption = 'Prazo Entrega'
        end
        object Label26: TLabel
          Left = 271
          Top = 8
          Width = 47
          Height = 16
          Caption = 'Data OS'
        end
        object ECodigo: TDBEdit
          Left = 9
          Top = 25
          Width = 76
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'codigo'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 0
        end
        object DBLEmpresa: TDBLookupComboBox
          Left = 91
          Top = 25
          Width = 174
          Height = 24
          DataField = 'empresaCodigo'
          DataSource = FDMOrdemServico.DOrdemServico
          KeyField = 'codigo'
          ListField = 'razaoSocial'
          ListSource = FDMOrdemServico.DEmpresa
          TabOrder = 1
        end
        object DBMemo1: TDBMemo
          Left = 594
          Top = 25
          Width = 373
          Height = 110
          DataField = 'detalhamento'
          DataSource = FDMOrdemServico.DOrdemServico
          ScrollBars = ssVertical
          TabOrder = 4
        end
        object DBEdit1: TDBEdit
          Left = 91
          Top = 67
          Width = 180
          Height = 24
          TabStop = False
          DataField = 'clienteNome'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 6
        end
        object DBCliente: TDBEdit
          Left = 9
          Top = 67
          Width = 76
          Height = 24
          DataField = 'clienteCodigo'
          DataSource = FDMOrdemServico.DOrdemServico
          TabOrder = 5
          OnDblClick = DBClienteDblClick
          OnExit = DBClienteExit
        end
        object DBMemo2: TDBMemo
          Left = 594
          Top = 153
          Width = 373
          Height = 66
          DataField = 'observacao'
          DataSource = FDMOrdemServico.DOrdemServico
          ScrollBars = ssVertical
          TabOrder = 18
        end
        object DBEdit2: TDBEdit
          Left = 359
          Top = 67
          Width = 86
          Height = 24
          TabStop = False
          DataField = 'enderecoTipo'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 8
        end
        object DBEndereco: TDBEdit
          Left = 277
          Top = 67
          Width = 76
          Height = 24
          DataField = 'enderecoCodigo'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 7
          OnDblClick = DBEnderecoDblClick
        end
        object DBEdit4: TDBEdit
          Left = 451
          Top = 67
          Width = 136
          Height = 24
          TabStop = False
          DataField = 'enderecoCEP'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 9
        end
        object DBEdit5: TDBEdit
          Left = 9
          Top = 111
          Width = 193
          Height = 24
          TabStop = False
          DataField = 'enderecoLongradouro'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 10
        end
        object DBEdit6: TDBEdit
          Left = 208
          Top = 111
          Width = 76
          Height = 24
          TabStop = False
          DataField = 'enderecoNumero'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 11
        end
        object DBEdit7: TDBEdit
          Left = 290
          Top = 111
          Width = 86
          Height = 24
          TabStop = False
          DataField = 'enderecoBairro'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 12
        end
        object DBEdit8: TDBEdit
          Left = 382
          Top = 111
          Width = 205
          Height = 24
          TabStop = False
          DataField = 'enderecoComplemento'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 13
        end
        object DBEdit9: TDBEdit
          Left = 9
          Top = 153
          Width = 193
          Height = 24
          TabStop = False
          DataField = 'enderecoCidade'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 14
        end
        object DBEdit10: TDBEdit
          Left = 208
          Top = 153
          Width = 106
          Height = 24
          TabStop = False
          DataField = 'enderecoEstado'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 15
        end
        object DBEdit11: TDBEdit
          Left = 320
          Top = 153
          Width = 125
          Height = 24
          TabStop = False
          DataField = 'enderecoPais'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 16
        end
        object DBLookupComboBox1: TDBLookupComboBox
          Left = 451
          Top = 153
          Width = 136
          Height = 24
          DataField = 'finalidade'
          DataSource = FDMOrdemServico.DOrdemServico
          KeyField = 'descricao'
          ListField = 'descricao'
          ListSource = FDMOrdemServico.DFinalidade
          TabOrder = 17
        end
        object DBEdit12: TDBEdit
          Left = 91
          Top = 195
          Width = 178
          Height = 24
          TabStop = False
          DataField = 'transportadoraNome'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 20
        end
        object DBTransportadora: TDBEdit
          Left = 9
          Top = 195
          Width = 76
          Height = 24
          DataField = 'transportadoraCodigo'
          DataSource = FDMOrdemServico.DOrdemServico
          TabOrder = 19
          OnDblClick = DBTransportadoraDblClick
          OnExit = DBTransportadoraExit
        end
        object DBLookupComboBox2: TDBLookupComboBox
          Left = 276
          Top = 195
          Width = 194
          Height = 24
          DataField = 'tipoFrete'
          DataSource = FDMOrdemServico.DOrdemServico
          KeyField = 'descricao'
          ListField = 'descricao'
          ListSource = FDMOrdemServico.DTipoFrete
          TabOrder = 21
        end
        object DBEdit14: TDBEdit
          Left = 388
          Top = 25
          Width = 199
          Height = 24
          TabStop = False
          DataField = 'situacao'
          DataSource = FDMOrdemServico.DOrdemServico
          ReadOnly = True
          TabOrder = 3
        end
        object DBPrazoEntrega: TDateTimePicker
          Left = 476
          Top = 195
          Width = 111
          Height = 24
          Date = 44975.000000000000000000
          Time = 0.918185462964174800
          TabOrder = 22
          OnChange = DBPrazoEntregaChange
        end
        object DBDataOrdem: TDateTimePicker
          Left = 271
          Top = 25
          Width = 111
          Height = 24
          Date = 44975.000000000000000000
          Time = 0.918185462964174800
          TabOrder = 2
          OnChange = DBDataOrdemChange
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 29
        Width = 1355
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        object BReplicar: TSpeedButton
          Left = 0
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Replicar'
          ImageIndex = 8
          Images = FMenuPrincipal.ImageList1
          OnClick = BReplicarClick
          ExplicitLeft = 8
        end
        object BAprovar: TSpeedButton
          Left = 90
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Aprovar'
          ImageIndex = 9
          Images = FMenuPrincipal.ImageList1
          OnClick = BAprovarClick
          ExplicitLeft = 175
        end
        object BFaturar: TSpeedButton
          Left = 450
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Faturar'
          ImageIndex = 11
          Images = FMenuPrincipal.ImageList1
          OnClick = BFaturarClick
          ExplicitLeft = 444
          ExplicitTop = -6
        end
        object BReprovar: TSpeedButton
          Left = 180
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Reprovar'
          ImageIndex = 10
          Images = FMenuPrincipal.ImageList1
          OnClick = BReprovarClick
          ExplicitLeft = 163
          ExplicitTop = -6
        end
        object BConcluir: TSpeedButton
          Left = 360
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Concluir'
          ImageIndex = 14
          Images = FMenuPrincipal.ImageList1
          OnClick = BConcluirClick
          ExplicitLeft = 541
        end
        object BExecutar: TSpeedButton
          Left = 270
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Executar'
          ImageIndex = 13
          Images = FMenuPrincipal.ImageList1
          OnClick = BExecutarClick
          ExplicitLeft = 253
          ExplicitTop = 2
        end
        object BModelo: TSpeedButton
          Left = 540
          Top = 0
          Width = 90
          Height = 29
          Align = alLeft
          Caption = 'Modelo'
          ImageIndex = 8
          Images = FMenuPrincipal.ImageList1
          OnClick = BModeloClick
          ExplicitLeft = 458
        end
      end
    end
    object TBConsulta: TTabSheet
      Caption = 'Consulta'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1355
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BConsultar: TSpeedButton
          Left = 1126
          Top = 16
          Width = 96
          Height = 30
          Caption = 'Consultar'
          ImageIndex = 7
          Images = FMenuPrincipal.ImageList1
          OnClick = BConsultarClick
        end
        object LConsultaRazaoSocial: TLabel
          Left = 3
          Top = 0
          Width = 79
          Height = 16
          Caption = 'Detalhamento'
        end
        object SpeedButton1: TSpeedButton
          Left = 1222
          Top = 16
          Width = 96
          Height = 30
          Caption = 'Fechar'
          ImageIndex = 6
          Images = FMenuPrincipal.ImageList1
          OnClick = BFecharClick
        end
        object Label17: TLabel
          Left = 157
          Top = 0
          Width = 50
          Height = 16
          Caption = 'Empresa'
        end
        object EDetalhamento: TEdit
          Left = 3
          Top = 18
          Width = 149
          Height = 24
          TabOrder = 0
        end
        object DBLConsultaEmpresa: TDBLookupComboBox
          Left = 158
          Top = 18
          Width = 174
          Height = 24
          KeyField = 'codigo'
          ListField = 'razaoSocial'
          ListSource = FDMOrdemServico.DEmpresa
          TabOrder = 1
          OnKeyDown = DBLConsultaEmpresaKeyDown
        end
      end
      object GDados: TDBGrid
        Left = 0
        Top = 52
        Width = 1355
        Height = 514
        Align = alClient
        DataSource = FDMOrdemServico.DOrdemServico
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = GDadosDrawColumnCell
        OnDblClick = GDadosDblClick
        OnTitleClick = GDadosTitleClick
        Columns = <
          item
            Expanded = False
            FieldName = 'codigo'
            Title.Alignment = taCenter
            Title.Caption = 'Codigo'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'empresaNome'
            Title.Alignment = taCenter
            Title.Caption = 'Empresa'
            Width = 164
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataOrdemServico'
            Title.Alignment = taCenter
            Title.Caption = 'Data OS'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'situacao'
            Title.Alignment = taCenter
            Title.Caption = 'Situa'#231#227'o'
            Width = 119
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'clienteNome'
            Title.Alignment = taCenter
            Title.Caption = 'Cliente'
            Width = 155
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoTipo'
            Title.Alignment = taCenter
            Title.Caption = 'Tipo Endere'#231'o'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoCEP'
            Title.Alignment = taCenter
            Title.Caption = 'CEP'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoLongradouro'
            Title.Alignment = taCenter
            Title.Caption = 'Longradouro'
            Width = 154
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoNumero'
            Title.Alignment = taCenter
            Title.Caption = 'Numero'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoBairro'
            Title.Alignment = taCenter
            Title.Caption = 'Bairro'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoComplemento'
            Title.Alignment = taCenter
            Title.Caption = 'Complemento'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoCidade'
            Title.Alignment = taCenter
            Title.Caption = 'Cidade'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoEstado'
            Title.Alignment = taCenter
            Title.Caption = 'Estado'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'enderecoPais'
            Title.Alignment = taCenter
            Title.Caption = 'Pais'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'finalidade'
            Title.Alignment = taCenter
            Title.Caption = 'Finalidade'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'detalhamento'
            Title.Alignment = taCenter
            Title.Caption = 'Detalhamento'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'transportadoraNome'
            Title.Alignment = taCenter
            Title.Caption = 'Transportadora'
            Width = 194
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'tipoFrete'
            Title.Alignment = taCenter
            Title.Caption = 'Tipo Frete'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataPrazoEntrega'
            Title.Alignment = taCenter
            Title.Caption = 'Prazo Entrega'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'observacao'
            Title.Alignment = taCenter
            Title.Caption = 'Observa'#231#227'o'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cadastradoPor'
            Title.Alignment = taCenter
            Title.Caption = 'Cadastrado Por'
            Width = 143
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alteradoPor'
            Title.Alignment = taCenter
            Title.Caption = 'Alterado Por'
            Width = 152
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataCadastro'
            Title.Alignment = taCenter
            Title.Caption = 'Data Cadastro'
            Width = 154
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataAlteracao'
            Title.Alignment = taCenter
            Title.Caption = 'Data Altera'#231#227'o'
            Width = 153
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Alignment = taCenter
            Title.Caption = 'Status'
            Width = 61
            Visible = True
          end>
      end
      object CBMostrarInativo: TCheckBox
        Left = 0
        Top = 566
        Width = 1355
        Height = 17
        Align = alBottom
        Caption = 'Mostrar Inativos'
        TabOrder = 2
      end
    end
  end
end

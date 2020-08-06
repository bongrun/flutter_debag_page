# flutter_debug_page

Debug page

## Getting Started

### DebugRepository
```
import 'package:flutter_debug_page/model/HostModel.dart';
import 'package:flutter_debug_page/repository/AbstractDebugRepository.dart';

class DebugRepository extends AbstractDebugRepository {
  Future<List<HostModel>> hosts() async {
    return [
      HostModel(code: 'PROD', host: 'https://prod.com/api', deviceKey: 'prod'),
      HostModel(code: 'DEMO', host: 'https://demo.com/api', deviceKey: 'demo'),
      HostModel(code: 'LOCAL', host: 'https://local.com/api', deviceKey: 'local'),
    ];
  }

  Future<String> code() async {
    return '7182';
  }
}
```

### MultiRepositoryProvider
```
return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DebugRepository>(create: (context) => DebugRepository()),
        ...
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DebugBloc>(create: (BuildContext context) => DebugBloc(debugRepository: context.repository<DebugRepository>())..add(DebugInitEvent())),
          ...
        ],
        child: ...,
      ),
    );
```

### MaterialApp
```
import 'package:flutter_debug_page/bloc/DebugBloc.dart';

return MaterialApp(
    ...
    home: BlocBuilder<DebugBloc, DebugState>(builder: (context, debugState) {
        return ...;
    })
);
```

### HttpService
```
final url = (await DebugBloc().getCurrentHost()).host + uri;
```
#include <iostream>
using namespace std;


//helping functions
int isanumber(string s){
    if(s.length()>1)
                  return 1;
    else if (s[0]-'a' > -1 && s[0]-'a' <26)
         return 0;
    else
        return 1;
        }
float evalstring(string s){
      int size,temp,flag=0,i,frac=0;
      float num=0,counter=0.1;
      size=s.length();
      for (i=0;i<size;i++){
          if(flag==0){
                      if(s[i]=='.'){
                                   flag=1;
                                   continue;
  }                    else{
                           temp=s[i]-'0';
                           num=(10*num)+temp;
                           }
           }
           else {
                temp=s[i]-'0';
                num=num+(counter*temp);
                counter*=0.1;
                }
                }
                return num;
                }
////////////////
//////////////////////////////////////////////////


//classes

class Genlistnode{
      public:
      int flag;
      string atom;
      Genlistnode *next;
      Genlistnode *down;
      };


class value{
      public:
      int flag;
      float f;
      Genlistnode *p;
      };
      
class env{
      public:
      value *a[26]; 
      env *parent;
      env(){
      int i ;
      for(i=0;i<26;i++){
      a[i]=NULL;
      }
      }
      };


///////////////////////////



///special functions


Genlistnode *makelist(string &s){
            Genlistnode *head;
            Genlistnode *current;
            head=new Genlistnode;
            current=head;
            //current->flag=0;
            string substr;
            int pos;
            //s.erase(0,2);
            //s=a+' ';
          
             pos=s.find(" ",0);
             substr = s.substr(0,pos);
             s.erase(0,pos+1);
             if (substr!="(" && substr!=")"){
                current->atom=substr;
                current->flag=0;
                current->next=makelist(s);
                current->down=NULL;
                }
             else if (substr==")"){
                  //current->next=NULL;
                  //current->down=NULL;
                  delete head;
                  return NULL;
                  }
             else {
                  current->flag=1;
                  current->down=makelist(s);
                  current->next=makelist(s);
                  }
                  
                  return head;
                  }


value findinenv(char X,env &e){
      
     value v;
     if(e.a[X-'a']!=NULL){
     v=*e.a[X-'a'];
     return  v;}
    else{
          if (e.parent == NULL)
             cout<<"error value not found";
          else
               return findinenv(X,*e.parent);
                      }
}



void addtoenv(char X,value v,env &e){
     value *v1;
     v1=new value();
     *v1=v;
     e.a[X-'a']=v1;
     }


value evalnode(Genlistnode *p,env &e);
value evallist(Genlistnode *p,env &e);


value evalnode(Genlistnode *p,env &e){
      value v;

      if (p -> flag ==0) {
         if(isanumber(p->atom)){
                       v.flag=0;
                       v.f=evalstring(p->atom);
                      return v;}
         else
             return findinenv((p->atom)[0],e);
             }
      else
          return evallist(p->down,e);
          }



value evallist(Genlistnode *p,env &e){
      if(p->atom == "begin") {
                 p=p->next;
                 while (p->next!=NULL){
                       evalnode(p,e);
                       p=p->next;}
                 return evalnode(p,e);
                 }
      else if (p->atom =="if"){
           value v;
           v=evalnode(p->next,e);
           if(v.f ==1)
                  return evalnode(p->next->next,e);
           else
                  return evalnode(p->next->next->next,e);
                  }
      else if (p->atom =="while"){
           value v =evalnode(p->next,e);
           while(v.f==1){
                         evalnode(p->next->next,e);
                         v=evalnode(p->next,e);
                         }
		return evalnode(p->next,e);
                         }
      else if (p->atom == "define" ){
           value v=evalnode(p->next->next,e);
           string s;
           char c;
           s=p->next->atom;
           c=s[0];
           addtoenv(c,v,e);
	   return v;
           }
     else if (p->atom == "set" ){
           value v=evalnode(p->next->next,e);
           string s;
           char c;
           s=p->next->atom;
           c=s[0];
           addtoenv(c,v,e);
           return v;
           }
     else if (p->atom == "lambda" ){
           value v;
           v.flag=1;
           v.p=p;
           return v;
           }
      else if (p->atom == "+"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=v1.f+v2.f;
           return v;
           }
      else if (p->atom == "-"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=v1.f-v2.f;
           return v;
           }
      else if (p->atom == "*"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=v1.f*v2.f;
           return v;
           }
      else if (p->atom == "/"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=v1.f/v2.f;
           return v;
           }
      else if (p->atom == "=="){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=(v1.f==v2.f);
           return v;
           }
      else if (p->atom == "%"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           int temp1,temp2;
           temp1=(int)v1.f;
           temp2=(int)v2.f;
           v.f=temp1%temp2;
           return v;
           }
      else if (p->atom == "<"){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=(v1.f<v2.f);
           return v;
           }
      else if (p->atom == "<="){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=(v1.f<=v2.f);
           return v;
           }
      else if (p->atom == ">="){
           value v,v1,v2;
           v.flag=0;
           v1=evalnode(p->next,e);
           v2=evalnode(p->next->next,e);
           v.f=(v1.f>=v2.f);
           return v;
           }
       else if (p->flag == 1){
            value v;
            v=evallist(p->down,e);
            Genlistnode *arglist,*body,*func;
            func=v.p;
            arglist=func->next->down;
            body=func->next->next;
            env e1;
            e1.parent=&e;
            while (arglist!=NULL){
               addtoenv((arglist->atom)[0],evalnode(p->next,e),e1);
               p=p->next;
               arglist=arglist->next;
               }
            return evalnode(body,e1);
            }
        else {
         string s;
         s=p->atom;
         value v;
         v=findinenv(s[0],e);
         Genlistnode *arglist,*body,*func;
         func=v.p;
         arglist=func->next->down;
         body=func->next->next;
         env e1;
         e1.parent=&e;
         int counter=0;
         while (arglist!=NULL){
               addtoenv((arglist->atom)[0],evalnode(p->next,e),e1);
               p=p->next;
               arglist=arglist->next;
               counter++;
               }
         return evalnode(body,e1);
      }
}


int main(){
    string a;
    getline(cin,a);
    a.erase(0,2);
    a=a+' ';
    //cout<<a;
    value result;
    Genlistnode *c;
    c=makelist(a);
    //cout<<c->atom;
    env e;
    e.parent =NULL;
    result=evallist(c,e);
    cout<<result.f;
    cout<<"\n";
    //getch();
    return 0;
    }

#include <vector>
#include <iostream>
#include <stdio.h>
#include <map>
#include <algorithm>

#define forall(i,a,b)                   for(float i=a;i<b;i++)
#define tr(container,it )               for(typeof(container.begin()) it = container.begin(); it!=container.end();it++)
#define MAX_float 100000000;

using namespace std;


typedef vector<float> vf;
typedef vector<vf> vvf;
typedef vector<float> vf;
typedef pair<float,float> pi;
typedef map<pi,float> mapi;


/***DAG INFO******************************************/
vvf Graph;
vvf reGraph;
mapi edgeCost;
/****************************************************/

/****Task INFO*************************************/
vf taskPriority;
vf taskOrder;
vf processorAssigned;
vf taskFinish;
vf taskStart;
vf next;

///**********************************************////


//Processor INFO////////////////////////////////////
vvf schedule;
vf presentFinish;
vf executionTime;
vvf processorCost;
vf continousBottleneck;
vf lastIncreased;
vf gearNumber;
vf numberOfGears;
vf execEnergy;
vvf execLevel;
vvf energyLevel;
vvf idleCommunication;
vvf busyCommunication;
vf idleEnergy;
vf slack;
////////////////////////////////////////////////////

//Global Variables................................
float numTasks;
float numProcessors;
float numGears;
float iterationTime;
float idleEnergySum;
float execEnergySum;
float commEnergy;
float pairs;
//...................................................

void clearAll()    //Restores all variables to empty state
{
    Graph.clear();
    reGraph.clear();
    edgeCost.clear();
    taskPriority.clear();
    taskOrder.clear();
    processorAssigned.clear();
    taskFinish.clear();
    taskStart.clear();
    schedule.clear();
    next.clear();
    presentFinish.clear();
    executionTime.clear();
    processorCost.clear();
    continousBottleneck.clear();
    lastIncreased.clear();
    gearNumber.clear();
    numberOfGears.clear();
    execEnergy.clear();
    execLevel.clear();
    energyLevel.clear();
    idleCommunication.clear();
    busyCommunication.clear();  
    idleEnergy.clear();
    slack.clear();
    numTasks=0;
    numProcessors=0;
    numGears=0;
    iterationTime=0;
    idleEnergySum=0;
    execEnergySum=0;
    commEnergy=0;
    pairs=0;
}

float maxVector(vf &v)
{
    float max=0;
    float maxValue=0;
    forall(i,0,v.size())
    {
        if (v[i]>maxValue)
        {
            max=i;
            maxValue=v[i];
        }
    }
    return max;
}

float minVector(vf &v)   //Finds minimum of a Vector
{
    float min=0;
    float minValue=MAX_float;
    forall(i,0,v.size())
    {
        if (v[i]<minValue)
        {
            min=i;
            minValue=v[i];
        }
    }
    return min;
}

char prfloatVector(vf v)               //Prints the content of the Vector     
{
    forall(i,0,v.size())
        cout<<v[i]<<" ";
    cout<<"\n";
}


float findSource()                  //Finds the source of DAG
{
    forall(i,0,numTasks)
    {
        if(reGraph[i].size()==0)
            return 0;
    }
}

float assignPriority(float source)
{
    float i;
    float temp;
    float avg=0,priority,max=0;
    for (i=0;i<numProcessors;i++)
        avg+=(processorCost[i][source])*(1+(execLevel[i][gearNumber[i]]/100.0));
    avg/=(numProcessors*1.0);
    vf childrens=Graph[source];
    for (i=0;i<childrens.size();i++)
    {
        temp=edgeCost[make_pair(source,childrens[i])]+assignPriority(childrens[i]);
        if (temp>max)
            max=temp;
    }
    priority=avg+max;
    taskPriority[source]=priority;
    return priority;
}


void findOrder(float source)        //Sorts tasks by priority value
{
    float max,maxVal,temp;
    forall(i,0,numTasks)
        taskOrder[i]=i;
    assignPriority(source);
    forall(i,0,numTasks)
    {   
        max=i;
        maxVal=taskPriority[i];
        forall(j,i,numTasks)
        {
            if (taskPriority[j]>maxVal)
            {
                max=j;
                maxVal=taskPriority[j];
            }
        }
        swap(taskOrder[i],taskOrder[max]);
    }
}

float parentsFinish(float task,float processor)         //Finds the earliest time by which process can start or all parents finish
{
    vf parentsList;
    float commCost,parent,latestParent;
    parentsList=reGraph[task];
    float numParents=parentsList.size();
    vf finishTime(numParents);
    if (numParents==0)
        return 0;
    forall(i,0,numParents)
    {
        parent=parentsList[i];
        commCost=processorAssigned[parent]==processor ? 0 : edgeCost[make_pair(parent,task)];
        finishTime[i]=taskFinish[parent]+commCost;
    }
    latestParent=maxVector(finishTime);     
    return finishTime[latestParent];
}

void scheduling()       //Assigns the processors according to earliest finishing heuristics
{    
    float task,selected;
    vf finishTime(numProcessors);
    forall(i,0,numTasks)
    {
        forall(j,0,numProcessors)
            finishTime[j]=0;
        task=taskOrder[i];
        forall(j,0,numProcessors)
            finishTime[j]+=parentsFinish(task,j);
        forall(j,0,numProcessors)
            finishTime[j]=max(finishTime[j],presentFinish[j]);
        forall(j,0,numProcessors)
            finishTime[j]+=(processorCost[j][task]*(1+(execLevel[j][gearNumber[j]]/100.0)));
        selected=minVector(finishTime);
        schedule[selected].push_back(task);
        taskFinish[task]=finishTime[selected];
        taskStart[task]=finishTime[selected]-(processorCost[selected][task]*(1+(execLevel[selected][gearNumber[selected]]/100.0)));
        processorAssigned[task]=selected;
        executionTime[selected]+=(processorCost[selected][task]*(1+(execLevel[selected][gearNumber[selected]]/100.0)));
        presentFinish[selected]=finishTime[selected];
    }
}
void setNext()              //Finds next task for a task on processor
{
    forall(i,0,numProcessors)
    {
        vf taskOnProcessor = schedule[i];
        taskOnProcessor.push_back(-1);
        float j=0;
        while ( taskOnProcessor[j]!=-1)
        {
            next[taskOnProcessor[j]]=taskOnProcessor[j+1];
            j++;
        }
    }
}

void findSlack()        //Computes slack on all processors
{
   forall(i,0,numTasks)
    {
        float task=taskOrder[i];
        float processor=processorAssigned[task];
        vf parentsList;
        float commCost,parent,latestParent,latestTime,nextTask;
        parentsList=reGraph[task];
        float numParents=parentsList.size();
        vf finishTime(numParents);
        if (numParents==0)
            continue;
        forall(j,0,numParents)
        {
            parent=parentsList[j];
            commCost=processorAssigned[parent]==processor ? 0 : edgeCost[make_pair(parent,task)];
            finishTime[j]=taskFinish[parent]+commCost;
        }
        
        latestParent=maxVector(finishTime);
        latestTime=finishTime[latestParent];
        forall(j,0,numParents)
        {
            parent=parentsList[j];
            if (next[parent]!=-1)
                nextTask=min(taskStart[next[parent]],latestTime);
            else
                nextTask=latestTime;
            slack[processorAssigned[parent]]+=(nextTask-taskFinish[parent]);
        }
    }
    
    
    iterationTime=presentFinish[maxVector(presentFinish)];
    forall(i,0,numProcessors)
        slack[i]/=iterationTime;  //Gross Slack
    float minSlack=MAX_float;
    forall(i,0,numProcessors)
    {
        if (slack[i]<minSlack)
            minSlack=slack[i];
    }
    forall(i,0,numProcessors)
        slack[i]-=minSlack;         //Net Slack   
}

void energyCalculation()
{
    idleEnergySum=0;
    execEnergySum=0;
    float commcost;
    
    
    forall(i,0,numProcessors)
    {
        idleEnergySum+=((iterationTime-executionTime[i])*idleEnergy[i]);
        execEnergySum+=executionTime[i]*(execEnergy[i]*(1-energyLevel[i][gearNumber[i]]/100));
    }
    
    
    
    commEnergy=0;
    forall(i,0,numProcessors)
    {
        forall(j,0,numProcessors)
            commEnergy+=idleCommunication[i][j]*iterationTime;
    }
    forall(i,0,numTasks)
    {
        vf a=Graph[i];
        forall(j,0,a.size())
        {
            float child=a[j];
            float parent=i;
            float commcost=busyCommunication[processorAssigned[child]][processorAssigned[parent]];
            commcost-=idleCommunication[processorAssigned[child]][processorAssigned[parent]];
            commcost*=edgeCost[make_pair(parent,child)];
            if(processorAssigned[child]!=processorAssigned[parent])
                commEnergy+=commcost;
        }
    }
    
    
    
            
    
}

void heft(float source)
{
    findOrder(source);
    scheduling();
    setNext();
    findSlack();
    energyCalculation();

}


void output()
{
    cout<<"\n--------------------------------\n";
    cout<<"Makespan =     "<<iterationTime<<"\n";
    cout<<"Energy Processor (busy,idle)=     ("<<execEnergySum<<","<<idleEnergySum<<")\n";
    cout<<"Energy Communication = ("<<commEnergy<<")\n";
    cout<<"Total Energy =     "<<execEnergySum+idleEnergySum+commEnergy<<"\n";
    cout<<"----------------------------------\n";
    cout<<"Edgelist -------------------------\n";
    forall(i,0,numTasks)
    {
        vf a=Graph[i];
        forall(j,0,a.size())
        {
            float parent=i;
            float child=Graph[i][j];
            float commCost=busyCommunication[processorAssigned[child]][processorAssigned[parent]];
            if (processorAssigned[child]!=processorAssigned[parent])
                cout<<"Edge from "<<parent<<" "<<processorAssigned[parent]<<" - "<<child<<" "<<processorAssigned[child]<<" "<<commCost<<"\n";
        }
    }
    
    cout<<"\n\nSchedule on processors ----- Proc id    jobid [start,finish]\n";
    forall(i,0,numProcessors)
    {
        cout<<"Processor "<<i<<" ";
        vf a=schedule[i];
        forall(j,0,a.size())
            cout<<a[j]<<"["<<taskStart[a[j]]<<","<<taskFinish[a[j]]<<"]"<<" ";
        if (a.size()==0)
            cout<<"--";
        cout<<"\n";
    }
    
                
}

void jitter()
{
    float S=0.15;
    vf dFactor(numProcessors,1);
    vf uFactor(numProcessors,1);
    vf oldGears(numProcessors,-1);
    float bias=2,count;
    float alpha=0.7;
    float presentIteration=iterationTime;
    float source;
    source=findSource();
    heft(source);
    while(count!=4)
    {
        if(oldGears==gearNumber)
            count++;
        else
            count=0;
        forall(i,0,numProcessors)
        {
            if (slack[i]>(S*dFactor[i]))
            {
                if (gearNumber[i]<numberOfGears[i]-1)
                    gearNumber[i]++;
                dFactor[i]*=bias;
                continousBottleneck[i]=0;
                lastIncreased[i]=1;
            }
            else if (slack[i]<alpha*(S/uFactor[i]))
            {
                continousBottleneck[i]+=1;
                if ((lastIncreased[i] && presentIteration < iterationTime) || continousBottleneck[i]==3)
                {
                    if(gearNumber[i]>0)
                        gearNumber[i]--;
                    uFactor[i]*=bias;
                    continousBottleneck[i]=0;
                }
                lastIncreased[i]=0;
            }
        }
        presentIteration=iterationTime;
        forall(i,0,numProcessors)
            oldGears[i]=gearNumber[i];
        forall(i,0,numProcessors)
        {
            vf t;
            slack[i]=0;
            schedule[i]=t;
            executionTime[i]=0;
            presentFinish[i]=0;
        }                 
        heft(source);
    }
        output();
}

int main()
{
    float numEdges;
    int hyperPeriod,t_id,t_rtime,t_period,t_dline;
    float tasks;
    float a=0,b,cost,d;
    cin>>hyperPeriod;
    cin>>tasks;
    forall(ta,0,tasks)
    {
        
        cin>>numProcessors;
        cin>>t_id>>t_rtime>>t_period>>t_dline;
        cin>>numTasks;
        forall(i,0,numTasks)   //Initialising all the task info vectors
        {
            vf a;
            Graph.push_back(a);
            reGraph.push_back(a);
            taskPriority.push_back(0);
            next.push_back(0);
            taskOrder.push_back(0);
            processorAssigned.push_back(0);
            taskFinish.push_back(-1);
            taskStart.push_back(-1);
        }
        forall(i,0,numProcessors)       //Initialising all the processor  info vectors
        {
            vf a(numTasks);
            vf t;
            vf b(numProcessors,0);
            idleCommunication.push_back(b);
            busyCommunication.push_back(b);
            presentFinish.push_back(0);
            executionTime.push_back(0);
            schedule.push_back(t);
            slack.push_back(0);
            gearNumber.push_back(0);
            continousBottleneck.push_back(0);
            lastIncreased.push_back(0);
            execLevel.push_back(t);
            energyLevel.push_back(t);
            numberOfGears.push_back(1);
            execEnergy.push_back(0);
            idleEnergy.push_back(0);
            processorCost.push_back(a);
        }
        forall(i,0,numTasks)            //Taking different processor cost for a task input
        {
            forall(j,0,numProcessors)
                cin>>processorCost[j][i];
        }
        while(true)                     //Commumnication cosr between different task input
        {
            cin>>a;
            if(a==-1)
                break;
            cin>>b>>cost;
            Graph[a].push_back(b);
            reGraph[b].push_back(a);
            edgeCost[make_pair(a,b)]=cost;
        }
        forall(i,0,numProcessors)
            cin>>idleEnergy[i]>>execEnergy[i];
        pairs=((numProcessors)*(numProcessors-1))/2;
        forall(i,0,pairs)           //Communication energy between different process
        {
            float cost1,cost2;
            cin>>a>>b>>cost1>>cost2;
            idleCommunication[a][b]=cost1;
            idleCommunication[b][a]=cost1;
            busyCommunication[a][b]=cost2;
            busyCommunication[b][a]=cost2;
        }   
        forall(i,0,numProcessors)       //Different energy and execution time at different gear level of the processor
        {
            execLevel[i].push_back(0);
            energyLevel[i].push_back(0);
            
            while(true)
            {   
                cin>>a;
                if(a==-1)
                    break;
                numberOfGears[i]++;
                cin>>b;
                execLevel[i].push_back(a);
                energyLevel[i].push_back(b);
            }
        }
        jitter();
    clearAll();
    }
    return 0;
}
        
        

        
        
            
        
        

    
     